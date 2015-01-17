//
//  VenueDetailsPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsPresenter: BasePresenter {
  
  
  var venueDetailsInteractor: VenueDetailsInteractor?
  var venueDetailsWireframe: VenueDetailsWireframe?
  var userInterface: VenueDetailsViewController?
  
  var historyPlaylist: [PlaylistTrack]?
  var upcomingPlaylist: [PlaylistTrack]?
  var nowPlaying: PlaylistTrack?
  
  func onViewLoadFinish() {
    userInterface?.updateNowPlaying(PlaylistTrack())
    if let preloadedVenue = venueDetailsWireframe?.venue {
      if(preloadedVenue.id != 0) {
        userInterface?.updateHeader(preloadedVenue)
      }
    }
    showActivityIndicator()
    venueDetailsInteractor?.getVenueDetails(venueDetailsWireframe!.venue.id, result: { (error, venue) -> () in
      if(error == nil) {
        // TODO: show error
        debugPrintln(error)
      }
      else if let loadedVenue = venue {
        self.userInterface?.updateHeader(loadedVenue)
      }
      self.hideActivityIndicator()
    })
    
    // Tell the interactor that UI is ready, so that socket can start
    venueDetailsInteractor?.userInterfaceReady()
  }
  
  // MARK: - Socket Events
  
  func onTracksLoaded(error: NSError?, historyPlaylist: [PlaylistTrack]?, upcomingPlaylist: [PlaylistTrack]?) {
    hideActivityIndicator()
    updateTracksList()
  }
  
  // MARK: - UI Update Delegation
  
  func updateNowPlaying() {
    if let track = nowPlaying {
      self.userInterface!.updateNowPlaying(track)
    }
  }
  
  func updateTracksList() {
    self.userInterface!.updateTracksList()
  }
  
  // MARK: - Helpers
  
  func showActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func hideActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  func backPressed(sender: AnyObject?) {
    userInterface?.navigationController?.popViewControllerAnimated(true)
  }
}

//
//  VenueDetailsPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let RequestButtonTag = 77

class VenueDetailsPresenter: BasePresenter {
  
  
  var venueDetailsInteractor: VenueDetailsInteractor?
  var venueDetailsWireframe: VenueDetailsWireframe?
  var userInterface: VenueDetailsViewController?
  
  var historyPlaylist: [PlaylistTrack]?
  var upcomingPlaylist: [PlaylistTrack]?
  var nowPlaying: PlaylistTrack?
  
  var progressIntervalTimer: NSTimer?
  
  func onViewLoadFinish() {
    userInterface?.updateNowPlaying(PlaylistTrack())
    if let preloadedVenue = venueDetailsWireframe?.venue {
      if(preloadedVenue.id != 0) {
        userInterface?.updateHeader(preloadedVenue)
      }
    }
    showActivityIndicator()
    updateVenueDetails()
    
    // Tell the interactor that UI is ready, so that socket can start
    venueDetailsInteractor?.userInterfaceReady()
  }
  
  // MARK: - Socket Events
  
  func onTracksLoaded(error: NSError?, historyPlaylist: [PlaylistTrack]?, upcomingPlaylist: [PlaylistTrack]?) {
    hideActivityIndicator()
    updateTracksList()
  }
  
  // MARK: - UI Lifecycle
  
  func viewWillDisappear() {
    
  }
  
  func viewDidDisappear() {
    self.venueDetailsInteractor?.userInterfaceWillHide()
  }
  
  func viewWillAppear() {
    self.venueDetailsInteractor?.userInterfaceWillShowAgain()
    updateVenueDetails()
  }
  
  func applicationWillResign(notification: NSNotification) {
    self.venueDetailsInteractor?.userInterfaceWillHide()
  }
  
  func applicationWillEnterForeground(notification: NSNotification) {
    self.venueDetailsInteractor?.userInterfaceWillShowAgain()
  }
  
  // MARK: - UI Update Delegation
  
  func updateVenueDetails() {
    venueDetailsInteractor?.getVenueDetails(venueDetailsWireframe!.venue.id, result: { (error, venue) -> () in
      if(error != nil) {
        // TODO: show error
        debugPrintln(error)
      }
      else if let loadedVenue = venue {
        self.venueDetailsWireframe?.venue = loadedVenue
        self.userInterface?.updateHeader(loadedVenue)
        self.nowPlaying = loadedVenue.nowPlaying
        self.updateNowPlaying()
      }
      self.hideActivityIndicator()
    })
  }
  
  func updateNowPlaying() {
    if let track = nowPlaying {
      self.userInterface?.updateNowPlaying(track)
    }
  }
  
  func updateTracksList() {
    self.userInterface?.updateTracksList()
  }
  
  func didUpdateNowPlaying(track: PlaylistTrack?) {
    if let existingTrack = track {
      nowPlaying = existingTrack
    }
    else {
      nowPlaying = PlaylistTrack() // dummy track
    }
    updateNowPlaying()
  }
  
  func didUpdateHistoryTracksList(historyTracks: [PlaylistTrack]) {
    self.historyPlaylist = historyTracks
    updateTracksList()
  }
  
  func didUpdateUpcomingPlaylist(upcomingTracks: [PlaylistTrack]) {
    self.upcomingPlaylist = upcomingTracks
    updateTracksList()
  }
  
  // MARK: - Progress Bar
  
  func startProgress(track: PlaylistTrack) {
    resetProgress()
    let interval = NSTimeInterval(track.duration / 100)
    progressIntervalTimer = NSTimer(timeInterval: interval, target: self, selector: "updateProgress:", userInfo: nil, repeats: true)
  }
  
  func stopProgress() {
    progressIntervalTimer?.invalidate()
  }
  
  func updateProgress(sender: AnyObject?) {
    if let ui = userInterface {
      ui.trackProgress.setProgress(ui.trackProgress.progress + 1, animated: true)
      if(ui.trackProgress.progress == 100) {
        stopProgress()
      }
    }
  }
  
  func resetProgress() {
    userInterface?.trackProgress.setProgress(0, animated: true)
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
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let button = sender as? UIButton {
      if(button.tag == RequestButtonTag) {
        if let window = UIApplication.sharedApplication().delegate?.window? {
          if let viewController = segue.destinationViewController as? SearchTracksViewController {
            venueDetailsWireframe?.searchTracksWireframe?.configureDependencies(window, viewController: viewController)
            venueDetailsWireframe?.passVenueToDetails()
          }
        }
      }
    }
  }
}

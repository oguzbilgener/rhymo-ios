//
//  SearchTracksPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SearchTracksPresenter: BasePresenter, UISearchBarDelegate {
  
  
  var searchTracksInteractor: SearchTracksInteractor?
  var searchTracksWireframe: SearchTracksWireframe?
  var userInterface: SearchTracksViewController?
  
  var displayedTracks = [Track]()
  
  // MARK: - Search Events
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchTrack(searchText)
  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    userInterface?.showCancelItem()
    return true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchTrack("")
    userInterface?.hideCancelItem()
    userInterface?.closeSearchBar()
  }
  
  func searchTrack(keyword: String) {
    showActivityIndicator()
    if let interactor = searchTracksInteractor {
      interactor.getTracksByName(keyword, result: { (error, tracks) -> () in
        if(error != nil) {
          // TODO: display an error message maybe?
          debugPrintln(error)
        }
        else {
          self.displayedTracks = tracks
          self.updateTracksList()
        }
        self.hideActivityIndicator()
      })
    }
  }
  
  // MARK: - UI Update Delegation
  
  func updateTracksList() {
    userInterface?.updateTracksList()
  }
  
  func clearTracksList() {
    if(countElements(displayedTracks) > 0) {
      displayedTracks.removeAll(keepCapacity: false)
    }
    updateTracksList()
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
    if let cell = sender as? UITableViewCell {
      if let path = userInterface?.trackResultsTable.indexPathForCell(cell) {
        if let window = UIApplication.sharedApplication().delegate?.window? {
          if let viewController = segue.destinationViewController as? RequestConfirmViewController {
            searchTracksWireframe?.requestConfirmWireframe?.configureDependencies(window, viewController: viewController)
            searchTracksWireframe?.passVenueAndTrackToDetails(track: displayedTracks[path.row])
          }
        }
      }
    }
  }
}

//
//  VenuesListPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import CoreLocation

class VenuesListPresenter: BasePresenter, UISearchBarDelegate {
  
  var venuesListInteractor: VenuesListInteractor?
  var venuesListWireframe: HomeWireframe?
  var userInterface: VenuesListViewController?
  
  var lastLocation: CLLocation?
  var venues = [Venue]()
  var filteredVenues = [Venue]()
  
  // MARK: - Refresh Events
  
  func refresh(refreshControl: VenuesListRefreshControl) {
    refreshControl.beginRefreshing()
    userInterface?.venuesTable.contentOffset = CGPoint(x:0, y:-60)
    showActivityIndicator()

    if let interactor = venuesListInteractor {
      
      if(interactor.lastLocationValid() == false) {
        interactor.getDeviceLocation({ (success, failReason, location) -> () in
          if(success) {
            // Now that we have the device location, we can ask the server what venues are nearby
            self.loadVenuesList(refreshControl, location: location!)
          }
          else {
            // TODO: show alert, etc
            debugPrintln("location failed: \(failReason)")
          }
          refreshControl.endRefreshing()
          self.hideActivityIndicator()
        })
      }
      else {
        self.loadVenuesList(refreshControl, location: interactor.lastLocation!)
      }
    }
  }
  
  func onViewLoadFinish(refreshControl: VenuesListRefreshControl) {
    refresh(refreshControl)
    // maybe do other things later
  }
  
  
  // MARK: - Search Events
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    searchInVenues(searchText)
  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    userInterface?.showCancelItem()
    return true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    searchInVenues("")
    userInterface?.hideCancelItem()
    userInterface?.closeSearchBar()
  }
  
  func searchInVenues(keyword: String) {
    if let interactor = venuesListInteractor {
      filteredVenues = interactor.filterVenuesByName(venues: venues, keyword: keyword)
      if let location = lastLocation {
        userInterface?.buildMap(location, venues: venues)
      }
      userInterface?.venuesTable.reloadData()
    }
  }
  
  // MARK: - Venue loading
  
  func loadVenuesList(refreshControl: UIRefreshControl, location: CLLocation) {
    venuesListInteractor?.getVenuesNearby(location, result: self.onVenuesLoaded(refreshControl: refreshControl, location: location))
  }
  
  func onVenuesLoaded(#refreshControl: UIRefreshControl, location: CLLocation)(error: NSError?, venues: [Venue]!) {
    // debug mode: make many duplicates of venues to fill the table view
    var duplicatedVenues = [Venue]()
    for i in 0..<20 {
      let v1 = Venue(venue: venues[0])
      let v2 = Venue(venue: venues[1])
      if(i % 2 == 0) {
        v1.online = false
        v2.online = false
      }
      else {
        v1.online = true
        v2.online = true
      }
      v1.name += String(2*i)
      v2.name += String(2*i+1)
      duplicatedVenues += [v1, v2]
    }
    self.venues = duplicatedVenues
    self.filteredVenues = self.venues
    self.lastLocation = location
    userInterface?.venuesTable.reloadData()
    userInterface?.buildMap(location, venues: venues)
    refreshControl.endRefreshing()
    hideActivityIndicator()
  }
  
  
  // MARK: - Helpers
  
  func showActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func hideActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  // MARK: - Segue delegation
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
  }
}

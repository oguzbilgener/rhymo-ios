//
//  VenuesListPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import CoreLocation

let kVenueDetailsIdentifier = "Show Venue Details"

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

    if let interactor = venuesListInteractor {
      
      if(interactor.lastLocationValid() == false) {
        interactor.getDeviceLocation({ (success, failReason, location) -> () in
          if(success) {
            self.showActivityIndicator()
            debugPrintln(location)
            // Now that we have the device location, we can ask the server what venues are nearby
            self.loadVenuesList(refreshControl, location: location!)
          }
          else {
            // TODO: show a better alert
            debugPrintln("location failed: \(failReason)")
            if let reason = failReason {
              let alertTitle = "Location failed"
              var alertBody = ""
              switch(reason) {
              case .Inaccurate:
                alertBody = "Device location is not accurate enough"
              case .NoPermission:
                alertBody = "Not allowed to obtain location"
              case .Timeout:
                alertBody = "Timeout while obtaining location"
              case .OtherError:
                alertBody = "Some other error"
              case .None:
                alertBody = "Some other other error"
              }
              let alert = UIAlertView(title: alertTitle, message: alertBody, delegate: nil, cancelButtonTitle: "Ok")
              alert.show()
              refreshControl.endRefreshing()
              self.hideActivityIndicator()
            }
          }
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
      updateVenuesList()
    }
  }
  
  // MARK: - Venue loading
  
  func loadVenuesList(refreshControl: UIRefreshControl, location: CLLocation) {
    venuesListInteractor?.getVenuesNearby(location, result: self.onVenuesLoaded(refreshControl: refreshControl, location: location))
  }
  
  func onVenuesLoaded(#refreshControl: UIRefreshControl, location: CLLocation)(error: NSError?, venues: [Venue]!) {
    if(error != nil && error?.code == RhymoUnauthorizedCode) {
      hideActivityIndicator()
      self.logout()
      return
    }
    self.venues = venues
    self.filteredVenues = self.venues
    self.lastLocation = location
    updateVenuesList()
    userInterface?.buildMap(location, venues: venues)
    refreshControl.endRefreshing()
    hideActivityIndicator()
    
    
    venuesListInteractor?.scanBeacons { venues in
      println(venues)
      if(venues.count > 0) {
        self.userInterface?.displayNearbyVenueSuggestion(venues[0])
      }
    }
  }
  
  func venueSuggestionViewUpdated(view: VenueSuggestionView) {
    let tapRecognizer = UITapGestureRecognizer(target: self, action: "venueSuggestionTapped:")
    view.addGestureRecognizer(tapRecognizer)
  }
  
  func venueSuggestionTapped(sender: AnyObject?) {
    userInterface?.performSegueWithIdentifier(kVenueDetailsIdentifier, sender: userInterface?.venueSuggestionView)
  }
  
  // MARK: - UI Update Delegation
  
  func updateVenuesList() {
    userInterface?.updateVenuesList()
  }
  
  
  // MARK: - Helpers
  
  func showActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func hideActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  func logout() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    appDelegate.appDependencies.logout(window: appDelegate.window!)
  }
  
  // MARK: - Segue delegation
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let window = UIApplication.sharedApplication().delegate?.window! {
      if let cell = sender as? UITableViewCell,
             path = userInterface?.venuesTable.indexPathForCell(cell) {
        if let viewController = segue.destinationViewController as? VenueDetailsViewController {
          venuesListWireframe?.venueDetailsWireframe?.configureDependencies(window, viewController: viewController)
          venuesListWireframe?.passVenueToDetails(filteredVenues[path.row])
        }
      }
      else if let view = sender as? VenueSuggestionView,
                  venue = view.displayedVenue {
        if let viewController = segue.destinationViewController as? VenueDetailsViewController {
          venuesListWireframe?.venueDetailsWireframe?.configureDependencies(window, viewController: viewController)
          venuesListWireframe?.passVenueToDetails(venue)
        }
      }
    }
  }
  
  func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
    if(identifier != nil && identifier! == kVenueDetailsIdentifier) {
      if let cell = sender as? UITableViewCell {
        if let path = userInterface?.venuesTable.indexPathForCell(cell) {
          // only open the venue details if the venue is online
          return filteredVenues[path.row].online
        }
      }
    }
    return true
  }
}

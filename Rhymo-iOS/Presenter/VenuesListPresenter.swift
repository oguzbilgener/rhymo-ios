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
  
  // MARK: - Refresh Events
  func refresh(refreshControl: VenuesListRefreshControl) {
    showActivityIndicator()

    if let interactor = venuesListInteractor {
      
      if(interactor.lastLocationValid() == false) {
        interactor.getDeviceLocation({ (success, failReason, location) -> () in
          if(success) {
            debugPrintln(location)
          }
          else {
            debugPrintln("location failed: \(failReason)")
          }
          refreshControl.endRefreshing()
          self.hideActivityIndicator()
        })
      }
    }
    else {
      refreshControl.endRefreshing()
      hideActivityIndicator()
    }
  }
  
  func onViewLoadFinish(refreshControl: VenuesListRefreshControl) {
    refresh(refreshControl)
    // maybe do other things later
  }
  
  // MARK: - Refresh action
  func loadVenuesList(location: CLLocation) {
    
  }
  
  // MARK: - Search Events
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    // TODO: Filter the list, update the UI accordingly
  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    userInterface?.showCancelItem()
    return true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    userInterface?.hideCancelItem()
    userInterface?.closeSearchBar()
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

//
//  VenuesListPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenuesListPresenter: BasePresenter, UISearchBarDelegate {
  
  var venuesListInteractor: VenuesListInteractor?
  var venuesListWireframe: HomeWireframe?
  
  var userInterface: VenuesListViewController?
  
  
  // MARK: - Search Events
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    debugPrintln("search text: "+searchText)
    // TODO: 
    // Filter the list,
    // update the UI accordingly
  }
  
  func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
    userInterface?.showCancelItem()
    return true
  }
  
  func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    userInterface?.hideCancelItem()
    userInterface?.closeSearchBar()
  }
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
  }
}

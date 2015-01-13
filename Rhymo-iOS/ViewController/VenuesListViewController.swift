//
//  VenuesListViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 13/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenuesListViewController: BaseViewController {
  
  var eventHandler: VenuesListPresenter?

  @IBOutlet weak var venuesTable: UITableView!
  
  var searchBar: UISearchBar?
  var refreshControl: VenuesListRefreshControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set up the search bar
    searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationController!.navigationBar.frame.size.height))
    searchBar?.delegate = eventHandler
    searchBar?.tintColor = textOnPrimaryColor
    searchBar?.placeholder = "Search Venues"
    searchBar?.searchBarStyle = UISearchBarStyle.Minimal
    searchBar?.tintColor = textOnPrimaryColor
    self.navigationItem.titleView = searchBar!
    
    // Set up the pull to refresh view
    refreshControl = VenuesListRefreshControl()
    refreshControl!.addTarget(eventHandler, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    venuesTable.addSubview(refreshControl!)
    
    eventHandler?.onViewLoadFinish(refreshControl!)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Search actions
  
  func closeSearchBar() {
    searchBar?.resignFirstResponder()
    searchBar?.text = ""
  }
  
  func showCancelItem() {
    searchBar?.setShowsCancelButton(true, animated: true)
  }
  func hideCancelItem() {
    searchBar?.setShowsCancelButton(false, animated: true)
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

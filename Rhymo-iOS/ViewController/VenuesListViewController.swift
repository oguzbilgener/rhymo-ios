//
//  VenuesListViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 13/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import MapKit

let VenuesListHeaderNibName = "VenuesListHeader"
let VenuesSectionHeaderNibName = "VenuesSectionHeader"

let MapViewTag = 21

class VenuesListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
  var eventHandler: VenuesListPresenter?

  @IBOutlet weak var venuesTable: UITableView!
  
  var searchBar: UISearchBar?
  var refreshControl: VenuesListRefreshControl?
  var mapView: MKMapView?
  
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
    
    venuesTable.dataSource = self
    venuesTable.delegate = self
    
    let tableBackgroundView = UIView(frame: venuesTable.bounds)
    tableBackgroundView.backgroundColor = containerBackgroundColor
    venuesTable.backgroundView = tableBackgroundView

    venuesTable.tableFooterView = UIView(frame: CGRectZero)
    
    // Set up the table header and map view
    let headerView = NSBundle.mainBundle().loadNibNamed(VenuesListHeaderNibName, owner: self, options: nil)[0] as UIView
    headerView.bounds.size.width = self.view.bounds.size.width
    mapView = headerView.viewWithTag(MapViewTag) as? MKMapView
    mapView!.bounds.size.width = self.view.bounds.size.width
    mapView!.updateConstraints()
    venuesTable.tableHeaderView = headerView
    
    venuesTable.registerNib(UINib(nibName: VenuesSectionHeaderNibName, bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "VenuesSectionHeader")
    
    eventHandler?.onViewLoadFinish(refreshControl!)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
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
  
  // MARK: - Table data population
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("VenueCell", forIndexPath: indexPath) as VenueCell
  
    let titleLabel = cell.venueTitle
    let descriptionLabel = cell.venueAddress
    let onlineIcon = cell.iconOnline
    let offlineIcon = cell.iconOffline
    
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    
    let venue = eventHandler!.filteredVenues[indexPath.row]
    
    titleLabel.text = venue.name
    descriptionLabel.text = venue.address
    
    if(venue.online) {
      titleLabel.textColor = textOnLightColor
      descriptionLabel.textColor = secondaryTextOnLightColor
      onlineIcon.hidden = false
      offlineIcon.hidden = true
    }
    else {
      titleLabel.textColor = disabledTextOnLightColor
      descriptionLabel.textColor = disabledSecondaryTextOnLightColor
      onlineIcon.hidden = true
      offlineIcon.hidden = false
    }
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let handler = eventHandler {
      return eventHandler!.filteredVenues.count
    }
    return 0
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 59
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("touched \(indexPath.row)")
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if(section == 0 && eventHandler != nil && eventHandler?.filteredVenues.count > 0) {
      var headerView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("VenuesSectionHeader") as? UITableViewHeaderFooterView
      if(headerView == nil) {
        headerView = NSBundle.mainBundle().loadNibNamed(VenuesSectionHeaderNibName, owner: self, options: nil)[0] as? UITableViewHeaderFooterView
      }
      headerView?.contentView.backgroundColor = containerBackgroundColor
      return headerView
    }
    return nil
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 33
  }
  
  // MARK: - map management
  func buildMap(location: CLLocation, venues: [Venue]) {
    if let mapView = self.mapView {
      let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      let region = MKCoordinateRegionMakeWithDistance(loc, 600, 600)
      mapView.region = region
      
      
      mapView.removeAnnotations(mapView.annotations)
      for venue in venues {
        let annotation = MKPointAnnotation()
        annotation.coordinate = venue.coord.asCoordinate
        annotation.title = venue.name
        mapView.addAnnotation(annotation)
      }
    }
  }
  
  func keyboardWillShow(notification: NSNotification) {
    // Prevent keyboard from overlapping the table view
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.venuesTable?.contentInset.bottom = self.venuesTable!.contentInset.bottom + keyboardSize.height
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    // Restore table view to its previous state
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
          self.venuesTable?.contentInset.bottom = self.venuesTable!.contentInset.bottom - keyboardSize.height
      }
    }
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

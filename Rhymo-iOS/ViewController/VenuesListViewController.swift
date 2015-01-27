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
let VenuesSectionTitleTag = 24

class VenuesListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
  
  var eventHandler: VenuesListPresenter?

  @IBOutlet weak var venuesTable: UITableView!
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?
  var searchBar: UISearchBar?
  var refreshControl: VenuesListRefreshControl?
  var mapView: MKMapView?
  var tableSectionHeaderView: UIView?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)

    // A little hack from https://www.codeschool.com/blog/2014/11/11/ios-app-creating-custom-nav-bar/
    weak var wSelf = self
    self.navigationController?.interactivePopGestureRecognizer.delegate = wSelf
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // define custom nav bar
    let originalBarFrame = self.navigationController!.navigationBar.frame
    let customBarFrame = CGRect(x: 0, y: 20, width: originalBarFrame.size.width, height: originalBarFrame.size.height)
    customNavigationBar = UINavigationBar(frame: customBarFrame)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    customNavigationBar!.barTintColor = UIColor(hue:0.98, saturation:0.8, brightness:0.79, alpha:1)
    customNavigationBar!.translucent = false
    customNavigationItem = UINavigationItem()
    customNavigationItem!.title = self.navigationItem.title
    customNavigationBar!.setItems([customNavigationItem!], animated: false)
    self.view.addSubview(customNavigationBar!)
    
    // TODO: fix this titlebg with AutoLayout
    let titlebg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    titlebg.backgroundColor = UIColor(hue:0.98, saturation:0.8, brightness:0.79, alpha:1)
    self.view.addSubview(titlebg)
    titlebg.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    
    
    
    // Set up the search bar
    searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: originalBarFrame.size.height))
    searchBar!.delegate = eventHandler
    searchBar!.tintColor = textOnPrimaryColor
    searchBar!.placeholder = "Search Venues"
    searchBar!.searchBarStyle = UISearchBarStyle.Minimal
    searchBar!.tintColor = textOnPrimaryColor
    customNavigationItem?.titleView = searchBar!

    customNavigationBar?.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 20))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: originalBarFrame.size.height))

//    self.view.addConstraint(NSLayoutConstraint(item: searchBar!, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
    
    self.venuesTable.contentInset.top = 44
    
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
    
    tableSectionHeaderView = NSBundle.mainBundle().loadNibNamed(VenuesSectionHeaderNibName, owner: self, options: nil)[0] as? UITableViewHeaderFooterView
    
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
    // segue already handles it
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return tableSectionHeaderView
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 33
  }
  
  func updateTableSectionHeaderView(venueCount: Int) {
    if let headerView = tableSectionHeaderView {
      if(venueCount > 0) {
        if let label = headerView.viewWithTag(VenuesSectionTitleTag) as? UILabel {
          label.textColor = primaryTextOnLightColor
          label.text = "Venues Around You"
        }
      }
      else {
        if let label = headerView.viewWithTag(VenuesSectionTitleTag) as? UILabel {
          label.textColor = disabledTextOnLightColor
          label.text = "No Venues Around"
        }
      }
    }
  }
  
  // MARK: - UI Update
  
  func updateVenuesList() {
    self.updateTableSectionHeaderView(self.eventHandler!.filteredVenues.count)
    dispatch_async(dispatch_get_main_queue()) {
      UIView.transitionWithView(self.venuesTable, duration: 0.2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
        self.venuesTable.reloadData()
        }, completion: nil)
    }
    // venuesTable.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
  }
  
  // MARK: - Map Management
  
  func buildMap(location: CLLocation, venues: [Venue]) {
    if let mapView = self.mapView {
      let loc = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
      let region = MKCoordinateRegionMakeWithDistance(loc, 600, 600)
      mapView.region = region
      
      mapView.zoomEnabled = false
      mapView.scrollEnabled = false
      mapView.rotateEnabled = false
      
      
      mapView.removeAnnotations(mapView.annotations)
      for venue in venues {
        let annotation = MKPointAnnotation()
        annotation.coordinate = venue.coord.asCoordinate
        annotation.title = venue.name
        mapView.addAnnotation(annotation)
      }
    }
  }
  
  // MARK: - Keyboard
  
  func keyboardWillShow(notification: NSNotification) {
    // Prevent keyboard from overlapping the table view
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.venuesTable.contentInset.bottom = self.venuesTable.contentInset.bottom + keyboardSize.height
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    // Restore table view to its previous state
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
          self.venuesTable.contentInset.bottom = self.venuesTable.contentInset.bottom - keyboardSize.height
      }
    }
  }  
  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    eventHandler?.prepareForSegue(segue, sender: sender)
  }
  
  override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
    if let handler = self.eventHandler {
      return handler.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }
    return false
  }
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }

}

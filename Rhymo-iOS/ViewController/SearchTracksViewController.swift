//
//  SearchTracksViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let SearchTracksAnimationDuration = 0.2

class SearchTracksViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet weak var trackResultsTable: UITableView!
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?
  var searchBar: UISearchBar?
  
  var eventHandler: SearchTracksPresenter?

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
    // Manually set a back bar ittem
    let backItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: eventHandler, action: "backPressed:")
    customNavigationItem!.leftBarButtonItem = backItem
    self.view.addSubview(customNavigationBar!)
    
    // TODO: fix this titlebg with AutoLayout, make it disappear when the screen is landscape
    let titlebg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    titlebg.backgroundColor = UIColor(hue:0.98, saturation:0.8, brightness:0.79, alpha:1)
    self.view.addSubview(titlebg)
    titlebg.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    
    self.trackResultsTable.contentInset.top = 44
    self.trackResultsTable.delegate = self
    self.trackResultsTable.dataSource = self
    
    let tableBackgroundView = UIView(frame: self.trackResultsTable.bounds)
    tableBackgroundView.backgroundColor = containerBackgroundColor
    self.trackResultsTable.backgroundView = tableBackgroundView
    
    // Put a "Powered by Fizy" banner to the bottom of the table
    let fizyPoweredImage = UIImage(named: "fizy_powered")
    let fizyPoweredImageView = UIImageView(frame: CGRect(x:0, y:0, width: 100, height: 21))
    fizyPoweredImageView.image = fizyPoweredImage
    let fizyPoweredContainer = UIView(frame: CGRect(x:0, y:0, width: trackResultsTable.frame.size.width, height: 44))
    self.trackResultsTable.tableFooterView = fizyPoweredContainer
    
    fizyPoweredContainer.addSubview(fizyPoweredImageView)
    fizyPoweredImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
    fizyPoweredContainer.addConstraint(NSLayoutConstraint(item: fizyPoweredImageView, attribute: .CenterX, relatedBy: .Equal, toItem: fizyPoweredContainer, attribute: .CenterX, multiplier: 1, constant: 0))
    fizyPoweredContainer.addConstraint(NSLayoutConstraint(item: fizyPoweredImageView, attribute: .CenterY, relatedBy: .Equal, toItem: fizyPoweredContainer, attribute: .CenterY, multiplier: 1, constant: 0))
    fizyPoweredContainer.addConstraint(NSLayoutConstraint(item: fizyPoweredImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 100))
    fizyPoweredContainer.addConstraint(NSLayoutConstraint(item: fizyPoweredImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 21))
    
    
    // Set up the search bar
    searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: originalBarFrame.size.height))
    searchBar!.delegate = eventHandler
    searchBar!.tintColor = textOnPrimaryColor
    searchBar!.placeholder = "Search Tracks"
    searchBar!.searchBarStyle = UISearchBarStyle.Prominent
    searchBar!.tintColor = textOnPrimaryColor
    customNavigationItem?.titleView = searchBar!
    
    customNavigationBar?.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 20))
    self.view.addConstraint(NSLayoutConstraint(item: customNavigationBar!, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: originalBarFrame.size.height))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table data population
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("SearchTrackCell", forIndexPath: indexPath) as SearchTrackCell
    
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    
    let track = eventHandler!.displayedTracks[indexPath.row]
    
    cell.trackNameLabel.text = track.name
    cell.trackArtistLabel.text = track.artistName
    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let handler = eventHandler {
      return handler.displayedTracks.count
    }
    return 0
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // segue already handles it
  }
  
  // TODO: Add a "Powered by Fizy" footer
  
  // MARK - UI Update
  
  func updateTracksList() {
    dispatch_async(dispatch_get_main_queue()) {
      UIView.transitionWithView(self.trackResultsTable, duration: SearchTracksAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
        self.trackResultsTable.reloadData()
        }, completion: nil)
    }
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
  
  // MARK: - Keyboard
  
  func keyboardWillShow(notification: NSNotification) {
    // Prevent keyboard from overlapping the table view
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.trackResultsTable.contentInset.bottom = self.trackResultsTable!.contentInset.bottom + keyboardSize.height
      }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    // Restore table view to its previous state
    if let userInfo = notification.userInfo {
      if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
        self.trackResultsTable.contentInset.bottom = self.trackResultsTable!.contentInset.bottom - keyboardSize.height
      }
    }
  }
  

  
  // MARK: - Navigation

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    eventHandler?.prepareForSegue(segue, sender: sender)
  }
  
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
}

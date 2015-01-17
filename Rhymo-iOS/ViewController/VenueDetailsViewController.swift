//
//  VenueDetailsViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import SDWebImage

let TracksSectionHeaderLabelIdentifier = 24
let VenueDetailsAnimationDuration = 0.3

class VenueDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
  
  var eventHandler: VenueDetailsPresenter?
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?

  @IBOutlet weak var venueCoverImageView: UIImageView!
  @IBOutlet weak var nowPlayingAlbumImageView: UIImageView!
  @IBOutlet weak var nowPlayingTitleLabel: UILabel!
  @IBOutlet weak var nowPlayingArtistLabel: UILabel!
  @IBOutlet weak var nowPlayingAlbumLabel: UILabel!
  @IBOutlet weak var venueSongTable: UITableView!
  @IBOutlet weak var requestButton: SolidButton!
  @IBOutlet weak var trackProgress: UIProgressView!
  
  
  var historySectionTitleView: UIView?
  var upcomingSectionTitleView: UIView?
  
  let imageManager = SDWebImageManager.sharedManager() // cannot use objc class extensions with swift :(
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    println(eventHandler?.venueDetailsWireframe?.venue)
    

    // Set up custom navigation bar
    customNavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 20, width: self.view.frame.width, height: 44))
    customNavigationBar!.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    customNavigationBar!.translucent = true
    customNavigationBar!.shadowImage = UIImage()
    customNavigationItem = UINavigationItem()
    customNavigationItem!.title = ""
    let shadow = NSShadow()
    shadow.shadowBlurRadius = 3
    shadow.shadowColor = shadowOnLightColor
    shadow.shadowOffset = CGSize(width:0, height:1)
    let font = UIFont(name: nowPlayingTitleLabel.font.fontName, size: 20)!
    let titleTextAttributes = [NSForegroundColorAttributeName: textOnPrimaryColor, NSShadowAttributeName: shadow, NSFontAttributeName: font]
    customNavigationBar!.titleTextAttributes = titleTextAttributes
    self.view.addSubview(customNavigationBar!)

    
    // Manually set a back bar ittem
    let backItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: eventHandler, action: "backPressed:")
    customNavigationItem!.leftBarButtonItem = backItem
    
    customNavigationBar!.setItems([customNavigationItem!], animated: false)
    
    // Set up songs table
    venueSongTable.delegate = self
    venueSongTable.dataSource = self
    
    historySectionTitleView = NSBundle.mainBundle().loadNibNamed("TracksSectionHeader", owner: self, options: nil)[0] as? UIView
    upcomingSectionTitleView = NSBundle.mainBundle().loadNibNamed("TracksSectionHeader", owner: self, options: nil)[0] as? UIView
//    venueSongTable.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TracksSectionHeader")
    
    venueSongTable.tableFooterView = UIView(frame: CGRectZero)
    
    eventHandler?.onViewLoadFinish()
  }
  
  func updateHeader(venue: Venue) {
    // update the title with given venue data
    customNavigationItem?.title = venue.name
    
    // the first one of venue's photos is the cover image
    if(venue.photos.count > 0) {
      // So download it
      let headerImgUrl = NSURL(string: venue.photos[0])
      imageManager.downloadImageWithURL(headerImgUrl, options: SDWebImageOptions.allZeros, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
        // TODO: add placeholder
        }) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
           // When completed, give it some blur and set it
          if(finished) {
            dispatch_async(dispatch_get_main_queue()) {
              UIView.transitionWithView(self.venueCoverImageView, duration: VenueDetailsAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
                self.venueCoverImageView.image = UIImageEffects.imageByApplyingBlurToImage(image, withRadius: 15, tintColor: UIColor(rgba: "#00000033"), saturationDeltaFactor: 1, maskImage: nil)
                }, completion: nil)
            }
          }
      }
    }
    
    dispatch_async(dispatch_get_main_queue()) {
      UIView.transitionWithView(self.requestButton, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
        if(venue.online) {
          self.requestButton.hidden = false
        }
        else {
          self.requestButton.hidden = true
        }
        }, completion: nil)
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Table data population
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell", forIndexPath: indexPath) as TrackCell
    
    let albumArtView = cell.albumArtView
    let nameLabel = cell.nameLabel
    let artistLabel = cell.artistLabel
    
    var albumArtUrl = NSURL(string: "")
    if(indexPath.section == 0) {
      nameLabel.textColor = disabledTextOnLightColor
      artistLabel.textColor = disabledSecondaryTextOnLightColor
      
      if let track = self.eventHandler?.historyPlaylist?[indexPath.row] {
        nameLabel.text = track.name
        artistLabel.text = track.artistName
        albumArtUrl = NSURL(string: track.albumCoverUrl)
      }
    }
    else {
      nameLabel.textColor = textOnLightColor
      artistLabel.textColor = secondaryTextOnLightColor
      
      if let track = self.eventHandler?.upcomingPlaylist?[indexPath.row] {
        nameLabel.text = track.name
        artistLabel.text = track.artistName
        albumArtUrl = NSURL(string: track.albumCoverUrl)
      }
    }
    

    imageManager.downloadImageWithURL(albumArtUrl, options: SDWebImageOptions.allZeros, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
      
      }) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
        // When completed, give it some blur and set it
        if(finished) {
          dispatch_async(dispatch_get_main_queue()) {
            UIView.transitionWithView(self.nowPlayingAlbumImageView, duration: VenueDetailsAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
              albumArtView.image = image
              }, completion: nil)
          }
        }
    }

    
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let handler = eventHandler {
      if(section == 0) {
        if let playlist = eventHandler?.historyPlaylist {
          return playlist.count
        }
      }
      else if(section == 1) {
        if let playlist = eventHandler?.upcomingPlaylist {
          return playlist.count
        }
      }
    }
    return 0
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 55
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    // segue already handles it
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    var view: UIView?
    if(section == 0) {
      view = historySectionTitleView
      if let label = historySectionTitleView!.viewWithTag(TracksSectionHeaderLabelIdentifier) as? UILabel {
        label.text = "Played Recently".uppercaseStringWithLocale(NSLocale.currentLocale())
      }
    }
    else {
      view = upcomingSectionTitleView
      if let label = upcomingSectionTitleView!.viewWithTag(TracksSectionHeaderLabelIdentifier) as? UILabel {
        label.text = "Upcoming".uppercaseStringWithLocale(NSLocale.currentLocale())
      }
    }
    return view
  }
  
  func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 33
  }
  
  // MARK: - UI Update
  
  func updateTracksList() {
    dispatch_async(dispatch_get_main_queue()) {
      UIView.transitionWithView(self.venueSongTable, duration: VenueDetailsAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
        self.venueSongTable.reloadData()
        }, completion: nil)
    }
  }
  
  func updateNowPlaying(track: PlaylistTrack) {
    self.nowPlayingTitleLabel.text = track.name
    self.nowPlayingArtistLabel.text = track.artistName
    self.nowPlayingAlbumLabel.text = track.albumName
    if(track.albumCoverUrl != "") {
      let coverUrl = NSURL(string: track.albumCoverUrl)
      imageManager.downloadImageWithURL(coverUrl, options: SDWebImageOptions.allZeros, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
        
        }) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
          if(finished) {
            dispatch_async(dispatch_get_main_queue()) {
              UIView.transitionWithView(self.nowPlayingAlbumImageView, duration: VenueDetailsAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
                self.nowPlayingAlbumImageView.image = image
                }, completion: nil)
            }
          }
      }
    }
    
    if(track.name == "") {
      trackProgress.setProgress(0, animated: false)
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

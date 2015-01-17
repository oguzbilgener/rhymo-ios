//
//  VenueDetailsViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import SDWebImage

class VenueDetailsViewController: BaseViewController {
  
  var eventHandler: VenueDetailsPresenter?
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?

  @IBOutlet weak var venueCoverImageView: UIImageView!
  @IBOutlet weak var nowPlayingAlbumImageView: UIImageView!
  @IBOutlet weak var nowPlayingTitleLabel: UILabel!
  @IBOutlet weak var NowPlayingArtistLabel: UILabel!
  @IBOutlet weak var venueSongTable: UITableView!
  
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
    let titleTextAttributes = [NSForegroundColorAttributeName: textOnPrimaryColor]
    customNavigationBar!.titleTextAttributes = titleTextAttributes
    self.view.addSubview(customNavigationBar!)

    
    // Manually set a back bar ittem
    let backItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: eventHandler, action: "backPressed:")
    customNavigationItem!.leftBarButtonItem = backItem
    
    customNavigationBar!.setItems([customNavigationItem!], animated: false)
    
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
        
        }) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
          // When completed, give it some blur and set it
          if(finished) {
            self.venueCoverImageView.image = UIImageEffects.imageByApplyingBlurToImage(image, withRadius: 10, tintColor: UIColor(rgba: "#00000033"), saturationDeltaFactor: 1, maskImage: nil)
          }
      }
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }

}

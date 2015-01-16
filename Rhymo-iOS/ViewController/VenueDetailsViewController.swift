//
//  VenueDetailsViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsViewController: BaseViewController {
  
  var eventHandler: VenueDetailsPresenter?
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?

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
    self.view.addSubview(customNavigationBar!)

    
    let backItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: eventHandler, action: "backPressed:")
    customNavigationItem!.leftBarButtonItem = backItem
    
    customNavigationBar!.setItems([customNavigationItem!], animated: false)
    
    eventHandler?.onViewLoadFinish()
  }
  
  func updateHeader(venue: Venue) {
    customNavigationItem?.title = venue.name
    
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

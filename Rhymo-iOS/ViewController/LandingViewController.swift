//
//  LandingViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
  
  var eventHandler: LandingPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()
    NSLog("landingViewDidLoad")
    if(eventHandler == nil) {
      NSLog("eventHandler nil")
    }
    else {
      NSLog("eventHandler not nil")
    }
        // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }


  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
  

  
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      eventHandler?.prepareForSegue(segue, sender: sender)
    }

}

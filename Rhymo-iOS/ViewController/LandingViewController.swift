//
//  LandingViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import AYVibrantButton

class LandingViewController: BaseViewController {
  
  var eventHandler: LandingPresenter?
  
  override func viewDidLoad() {

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

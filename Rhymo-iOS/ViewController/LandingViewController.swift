//
//  LandingViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import KASlideShow

class LandingViewController: BaseViewController {
  
  var eventHandler: LandingPresenter?
  var slideShow: KASlideShow?
  
  override func viewDidLoad() {
    slideShow = KASlideShow(frame: self.view.bounds)
    self.view.addSubview(slideShow!)
    self.view.sendSubviewToBack(slideShow!)
    slideShow!.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
    
    var coverItems = ["cover1", "cover2", "cover3", "cover4", "cover5", "cover6"]
//    var coverItemsShuffled = coverItems.shuffle()
    
    slideShow!.delay = 10
    slideShow!.transitionDuration = 1
    slideShow!.transitionType = KASlideShowTransitionType.Fade
    slideShow!.imagesContentMode = UIViewContentMode.ScaleAspectFill
    slideShow!.addImagesFromResources(coverItems)
    slideShow!.start()
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

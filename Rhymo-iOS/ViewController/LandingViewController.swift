//
//  LandingViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import KASlideShow

let kLandingModalDismissNotification = "DidDismissModalOfLandingViewController"

class LandingViewController: BaseViewController, KASlideShowDelegate, LandingModalDelegate {
  
  var eventHandler: LandingPresenter?
  var slideShow: KASlideShow?
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var logoImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var loginButton: InvertButton!
  @IBOutlet weak var registerButton: InvertButton!
  
  var coverDescriptions = [String]()
  
  override func viewDidLoad() {
    slideShow = KASlideShow(frame: self.view.bounds)
    self.view.addSubview(slideShow!)
    self.view.sendSubviewToBack(slideShow!)
    slideShow!.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Height, relatedBy: .Equal, toItem: self.view, attribute: .Height, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: slideShow!, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
    
    var coverItems = [("cover1","Listen to your favourite song while you share your moments with your friends"),
                      ("cover3", "Pick your song and be the DJ at your favourite club"),
                      ("cover4","Listen to quality music while hanging out with friends"),
                      ("cover5","The best thing about a coffee shop"),
                      ("cover6", "Have a cup of coffee along with your favourite artist")]
    coverItems.shuffle()
    
    descriptionLabel.text = ""
    
    var coverUrls = [String]()
    for pair in coverItems {
      coverUrls.append(pair.0)
      coverDescriptions.append(pair.1)
    }
    
    descriptionLabel.text = coverDescriptions[0]
    
    slideShow!.delegate = self
    slideShow!.delay = 10
    slideShow!.transitionDuration = 1
    slideShow!.transitionType = KASlideShowTransitionType.Fade
    slideShow!.imagesContentMode = UIViewContentMode.ScaleAspectFill
    slideShow!.addImagesFromResources(coverUrls)
    slideShow!.start()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  }
  
  func didDismissModal(sender: AnyObject?) {
      self.setContentVisibility(true)
  }
  
  func kaSlideShowDidNext(slideShow: KASlideShow) {
    let index = Int(slideShow.currentIndex)
    if(coverDescriptions.count > index) {
      UIView.transitionWithView(self.descriptionLabel, duration: 1, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
        self.descriptionLabel.text = self.coverDescriptions[index]
        }, completion: nil)
    }
  }
  
  func setContentVisibility(shown: Bool) {
    UIView.transitionWithView(self.view, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
      self.titleLabel.hidden = !shown
      self.descriptionLabel.hidden = !shown
      self.logoImageView.hidden = !shown
      self.loginButton.hidden = !shown
      self.registerButton.hidden = !shown
      }, completion: nil)
  }


  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }

  
  // MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let viewController = segue.destinationViewController as? LoginViewController {
      self.setContentVisibility(false)
      viewController.modalDelegate = self
    }
    else if let viewController = segue.destinationViewController as? RegisterViewController {
      self.setContentVisibility(false)
      viewController.modalDelegate = self
    }
    eventHandler?.prepareForSegue(segue, sender: sender)
  }

}

protocol LandingModalDelegate {
  func didDismissModal(sender: AnyObject?)
}

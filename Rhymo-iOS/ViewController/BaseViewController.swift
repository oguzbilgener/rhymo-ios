//
//  BaseViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  
  var transitioningBackgroundView : UIView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningBackgroundView.userInteractionEnabled = true
        // Do any additional setup after loading the view.
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

}

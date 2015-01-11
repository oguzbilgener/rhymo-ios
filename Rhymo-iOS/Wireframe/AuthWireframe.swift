//
//  AuthWireframe.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let LandingViewControllerIdentifier = "LandingViewController"

class AuthWireframe: BaseWireframe {

  var loginWireframe: LoginWireframe?
  var registerWireframe: RegisterWireframe?
  
  func presentLandingInterfaceFromWindow(window: UIWindow) {
    window.rootViewController = landingViewControllerFromStoryboard()
  }
  
  func landingViewControllerFromStoryboard() -> LandingViewController {
    return mainStoryboard().instantiateViewControllerWithIdentifier(LandingViewControllerIdentifier) as LandingViewController
  }
}

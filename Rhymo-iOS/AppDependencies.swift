//
//  AppDependencies.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation
import UIKit

class AppDependencies {
  
  var authenticatedUser: User?
  
  var rootWireframe = RootWireframe()
  
  init() {
    configureDependencies()
  }
  
  func installRootViewControllerIntoWindow(window: UIWindow) {
    
    authenticatedUser = RhymoClient.getAuthenticatedUser()
    if let user = authenticatedUser {
      NSLog("authenticated")
      rootWireframe.homeWireframe?.presentHomeInterfaceFromWindow(window)
    }
    else {
      NSLog("NOT authenticated")
//      var landingViewController = window.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("LandingViewController") as UIViewController
//      window.rootViewController?.dismissViewControllerAnimated(false, completion: { () -> Void in
//        NSLog("dismiss rvc")
//        window.rootViewController?.presentViewController(landingViewController, animated: false, completion: { () -> Void in
//          NSLog("show landing completed")
//        })
//      })
      
    }

  }
  
  func configureDependencies() {
    let authWireframe = AuthWireframe()
    let homeWireframe = HomeWireframe()
    
    rootWireframe.authWireframe = authWireframe
    rootWireframe.homeWireframe = homeWireframe
    
    let landingInteractor = LandingInteractor()
    let landingPresenter = LandingPresenter()

    
    
  }
}

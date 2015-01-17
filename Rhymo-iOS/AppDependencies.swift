//
//  AppDependencies.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation
import UIKit

let primaryColor = UIColor(rgba: "#B71221") // B71221 // C9011A
let darkPrimaryColor = UIColor(rgba: "#A0011A")
let accentColor = UIColor(rgba: "#F3F2F3")
let contentBackgroundColor = UIColor(rgba: "#FFFFFF")
let containerBackgroundColor = UIColor(rgba: "#FAF9FA")

let textOnPrimaryColor = UIColor(rgba: "#FFFFFF")
let darkerTextOnPrimaryColor = UIColor(rgba: "#FFFFFFDD")
let textOnLightColor = UIColor(rgba: "#000000")
let disabledTextOnLightColor = UIColor(rgba: "#666666")
let secondaryTextOnLightColor = UIColor(rgba: "#444444")
let disabledSecondaryTextOnLightColor = UIColor(rgba: "#888888")
let primaryTextOnLightColor = primaryColor
let shadowOnLightColor = UIColor(rgba: "#444444")

class AppDependencies {
  
  var authenticatedUser: User?
  
  var rootWireframe = RootWireframe()
  
  init() {
    configureDependencies()
  }
  
  func installRootViewControllerIntoWindow(window: UIWindow) {
    
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
    
    authenticatedUser = RhymoClient.getAuthenticatedUser()
    if let user = authenticatedUser {
      rootWireframe.homeWireframe?.presentHomeInterfaceFromWindow(window)
      rootWireframe.homeWireframe?.configureDependencies(window)
    }
    else {
      rootWireframe.authWireframe?.configureDependencies(window)
    }

  }
  
  func configureDependencies() {
    let authWireframe = AuthWireframe()
    let homeWireframe = HomeWireframe()
    
    let landingInteractor = LandingInteractor()
    let landingPresenter = LandingPresenter()
    
    rootWireframe.authWireframe = authWireframe
    rootWireframe.homeWireframe = homeWireframe
    
    authWireframe.authInteractor = landingInteractor
    authWireframe.authPresenter = landingPresenter
    
    landingPresenter.landingWireframe = authWireframe
    landingPresenter.landingInteractor = landingInteractor
    
    landingInteractor.output = landingPresenter
    
  }
}

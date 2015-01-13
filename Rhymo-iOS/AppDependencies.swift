//
//  AppDependencies.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation
import UIKit

let primaryColor = UIColor(rgba: "#C9011A")
let darkPrimaryColor = UIColor(rgba: "#A0011A")
let textOnPrimaryColor = UIColor(rgba: "#FFFFFF")

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
      rootWireframe.homeWireframe?.configureDependencies(window)
    }
    else {
      NSLog("NOT authenticated")
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

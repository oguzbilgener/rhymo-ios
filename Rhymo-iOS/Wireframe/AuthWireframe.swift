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

  var login: LoginWireframe?
  var register: RegisterWireframe?
  
  var authInteractor: LandingInteractor?
  var authPresenter: LandingPresenter?
  
  func presentLandingInterfaceFromWindow(window: UIWindow) {
    window.rootViewController = landingViewControllerFromStoryboard()
  }
  
  func landingViewControllerFromStoryboard() -> LandingViewController {
    return mainStoryboard().instantiateViewControllerWithIdentifier(LandingViewControllerIdentifier) as! LandingViewController
  }
  
  func configureDependencies(window: UIWindow) {
    login = LoginWireframe()
    register = RegisterWireframe()
    
    let loginInteractor = LoginInteractor()
    let loginPresenter = LoginPresenter()
    let registerInteractor = RegisterInteractor()
    let registerPresenter = RegisterPresenter()
    
    login?.loginInteractor = loginInteractor
    login?.loginPresenter = loginPresenter
    register?.registerInteractor = registerInteractor
    register?.registerPresenter = registerPresenter
    
    loginPresenter.loginInteractor = loginInteractor
    loginPresenter.loginWireframe = login
    registerPresenter.registerInteractor = registerInteractor
    registerPresenter.registerWireframe = register
    
    loginInteractor.output = loginPresenter
    registerInteractor.output = registerPresenter
    
    if let viewController = window.rootViewController as? LandingViewController {
      viewController.eventHandler = authPresenter
      authPresenter?.userInterface = viewController
    }
  }
}

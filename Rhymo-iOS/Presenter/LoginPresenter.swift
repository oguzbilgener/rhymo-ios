//
//  LoginPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class LoginPresenter: BasePresenter {
  
  var loginInteractor: LoginInteractor?
  var loginWireframe: LoginWireframe?
  
  var userInterface: LoginViewController?
  
  func cancel() {
    userInterface?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func login(#email: String, password: String) {
    NSLog("login")
  }
   
}

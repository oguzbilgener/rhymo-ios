//
//  LoginPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import JGProgressHUD

let LoginMaxDelay = NSTimeInterval(60)
let LoginResultDialogTimeout = NSTimeInterval(3)

class LoginPresenter: BasePresenter {
  
  var loginInteractor: LoginInteractor?
  var loginWireframe: LoginWireframe?
  
  var userInterface: LoginViewController?
  
  func cancel() {
    userInterface?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func login(#email: String, password: String) {
    let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    
    if(!loginInteractor!.validateLogin(email: email, password: password)) {
      hud.indicatorView = JGProgressHUDIndicatorView(contentView: UIView())
      hud.textLabel.text = "Please enter a username and a password."
      hud.showInView(self.userInterface?.view)
      hud.dismissAfterDelay(LoginResultDialogTimeout, animated: true)
    }
    else {
      hud.textLabel.text = "Logging in"
      hud.showInView(userInterface?.view)
      hud.dismissAfterDelay(LoginMaxDelay)
      
      loginInteractor!.login(email: email, password: password) {
        (authenticatedUser: User?) -> (Void) in
        hud.dismissAnimated(false)
        
        let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.indicatorView = JGProgressHUDIndicatorView(contentView: UIView())
        
        if let user = authenticatedUser {
          hud.textLabel.text = "Welcome back, "+user.userName+"!"
          hud.showInView(self.userInterface?.view)
          hud.dismissAfterDelay(LoginResultDialogTimeout, animated: true)
          
          NSLog("switch viewcontrollers")
          let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
          if let window = appDelegate.window {
            appDelegate.appDependencies.installRootViewControllerIntoWindow(window)
          }
        }
        else {
          hud.textLabel.text = "Login failed."
          hud.showInView(self.userInterface?.view)
          hud.dismissAfterDelay(LoginResultDialogTimeout, animated: true)
        }
      }
    }
  }
   
}

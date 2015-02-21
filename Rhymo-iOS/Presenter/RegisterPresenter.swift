//
//  RegisterPresenter.swift
//  Rhymo
//
//  Created by Oguz Bilgener on 27/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import JGProgressHUD

let RegisterMaxDelay = NSTimeInterval(60)
let RegisterResultDialogTimeout = NSTimeInterval(3)

class RegisterPresenter: BasePresenter {
  
  var registerInteractor: RegisterInteractor?
  var registerWireframe: RegisterWireframe?
  
  var userInterface: RegisterViewController?

  func cancel() {
    userInterface?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func register(#email: String, password: String) {
    let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
    
    let validationResult = registerInteractor!.validateRegister(email: email, password: password)
    if(validationResult == RegisterInteractor.RegisterValidationResult.FieldsEmpty) {
      hud.indicatorView = JGProgressHUDIndicatorView(contentView: UIView())
      hud.textLabel.text = "Please enter an email address and a password."
      hud.showInView(self.userInterface?.view)
      hud.dismissAfterDelay(RegisterResultDialogTimeout, animated: true)
    }
    else if(validationResult == RegisterInteractor.RegisterValidationResult.InvalidEmail) {
      hud.indicatorView = JGProgressHUDIndicatorView(contentView: UIView())
      hud.textLabel.text = "Please enter a valid email address."
      hud.showInView(self.userInterface?.view)
      hud.dismissAfterDelay(RegisterResultDialogTimeout, animated: true)
    }
    else {
      hud.textLabel.text = "Registering"
      hud.showInView(userInterface?.view)
      hud.dismissAfterDelay(RegisterMaxDelay)
      
      registerInteractor!.register(email: email, password: password) {
        (error: NSError?, authenticatedUser: User?) -> (Void) in
        hud.dismissAnimated(false)
        
        let hud = JGProgressHUD(style: JGProgressHUDStyle.Dark)
        hud.indicatorView = JGProgressHUDIndicatorView(contentView: UIView())
        
        if let user = authenticatedUser {
          if(user.userName != "") {
            hud.textLabel.text = "Welcome back, "+user.userName+"!"
          }
          else {
            hud.textLabel.text = "Welcome back!"
          }
          hud.showInView(self.userInterface?.view)
          hud.dismissAfterDelay(RegisterResultDialogTimeout, animated: true)
          
          let successTimer = NSTimer.scheduledTimerWithTimeInterval(RegisterResultDialogTimeout, target: self, selector: "registerSuccess:", userInfo: nil, repeats: false)
        }
        else {
          debugPrintln(error)
          hud.textLabel.text = "Register failed."
          hud.showInView(self.userInterface?.view)
          hud.dismissAfterDelay(RegisterResultDialogTimeout, animated: true)
        }
      }
    }
  }
  
  func registerSuccess(sender: AnyObject?) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    if let window = appDelegate.window {
      appDelegate.appDependencies.installRootViewControllerIntoWindow(window)
    }
  }
  
}

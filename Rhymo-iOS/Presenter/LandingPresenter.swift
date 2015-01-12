//
//  LandingPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class LandingPresenter: BasePresenter {
  
  let LoginViewControllerIdentifier = "LoginViewController"
  let RegisterViewControllerIdentifier = "RegisterViewController"
  
  var landingInteractor: LandingInteractor?
  var landingWireframe: AuthWireframe?
  
  var userInterface: LandingViewController?
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if(segue.identifier? == LoginViewControllerIdentifier) {
      // Get the view controller
      let loginViewController  = segue.destinationViewController as? LoginViewController
      // Set it as the userInterface for LoginPresenter
      landingWireframe?.login?.loginPresenter?.userInterface = loginViewController
      // Set its event handler as LoginPresenter
      loginViewController?.eventHandler = landingWireframe?.login?.loginPresenter
    }
    else if(segue.identifier? == RegisterViewControllerIdentifier) {
      
    }
  }
  
  func continueWithFacebook() {
    
  }
   
}

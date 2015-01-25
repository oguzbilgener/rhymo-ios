//
//  LoginInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class LoginInteractor: BaseInteractor {
  
  var output: LoginPresenter?
  
  func login(#email: String, password: String, result: (NSError?, User?) -> (Void)) {

    let client = RhymoClient()
    client.login(email: email, password: password, result: result)
  }
  
  func validateLogin(#email: String, password: String) -> Bool {
    if(email.isEmpty && password.isEmpty) {
      return false
    }
    return true
  }
   
}

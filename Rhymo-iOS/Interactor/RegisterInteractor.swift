//
//  RegisterInteractor.swift
//  Rhymo
//
//  Created by Oguz Bilgener on 27/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class RegisterInteractor: BaseInteractor {
  
  var output: RegisterPresenter?
  
  enum RegisterValidationResult: Int {
    case Valid = 0
    case FieldsEmpty
    case InvalidEmail
    // more?
  }
  
  func register(#email: String, password: String, result: (NSError?, User?) -> (Void)) {

    let client = RhymoClient()
    client.register(email: email, password: password, result: result)
  }
  
  func validateRegister(#email: String, password: String) -> RegisterValidationResult {
    if(email.isEmpty && password.isEmpty) {
      return RegisterValidationResult.FieldsEmpty
    }
    if (!RegisterInteractor.isValidEmail(email)) {
      return RegisterValidationResult.InvalidEmail
    }
    return RegisterValidationResult.Valid
  }
  
  class func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    
    var emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest!.evaluateWithObject(testStr)
  }

}

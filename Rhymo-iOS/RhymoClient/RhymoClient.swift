//
//  RhymoClient.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation
import Lockbox
import Alamofire
import SwiftyJSON

let RhymoEndpoint = "http://192.168.2.254:9000/v1/"

let kUser = "user_obj"
let kPublicKey = "public_key"
let kSecretToken = "secret_token"

class RhymoClient {
  
  private var authenticatedUser: User?
  
  init() {
    if let cachedUser = (UIApplication.sharedApplication().delegate as? AppDelegate)?.appDependencies.authenticatedUser {
      authenticatedUser = cachedUser
    }
    else {
      authenticatedUser = RhymoClient.getAuthenticatedUser()
    }
  }
  
  // MARK - Unauthenticated requests
  
  func login(#email: String, password: String, result: (User?) -> (Void)) {
    
    let loginUrl = RhymoEndpoint + "login"
    
    let parameters = [
      "email": email,
      "password": password
    ]

    let request = Alamofire.request(.POST, loginUrl, parameters: parameters, encoding: .JSON)
      .validate()
      .responseJSON {
        (request, response, data, error) in
        if(error == nil && data != nil) {
          var json = JSON(data!)
          var user = User()
          if let id = json["id"].int {
            user.id = id
          }
          if let username = json["user_name"].string {
            user.userName = username
          }
          if let email = json["email"].string {
            user.email = email
          }
          if let publicKey = json["public_key"].string {
              user.publicKey = publicKey
          }
          if let secretToken = json["secret_token"].string {
            user.secretToken = secretToken
          }
          if let birthday = json["birthday"].string {
            user.birthday = birthday
          }
          if let profilePic = json["profile_pic"].string {
            user.profilePic = profilePic
          }
          
          self.storeAuthenticatedUser(user)
          
          result(user)
        }
        else {
          result(nil)
        }
    }
  }
  
  func register() {
    
  }
  
  func logout() {
    let defaults = RhymoClient.getDefaults()
    
    defaults.removeObjectForKey(kUser)
    
    Lockbox.setString("", forKey: kPublicKey)
    Lockbox.setString("", forKey: kPublicKey)
    
    self.authenticatedUser = nil
  }
  
  // MARK: - Authenticated requests
  
  func getVenuesNearby(location: Point) {
    
  }
  
  // MARK: - Authentication helpers

  class func getAuthenticatedUser() -> User? {
    
    let defaults = RhymoClient.getDefaults()
    
    // get the user object from an unencrypted data store
    if let data = defaults.objectForKey(kUser) as? NSData {
      let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as User
      // fill the public key and secret token from an encrypted data store
      let publicKey = Lockbox.stringForKey(kPublicKey)
      let secretToken = Lockbox.stringForKey(kSecretToken)
      
      user.publicKey = publicKey
      user.secretToken = secretToken
      
      return user
    }
    return nil
  }
  
  private func storeAuthenticatedUser(user: User) {
    
    let publicKey = user.publicKey
    let secretToken = user.secretToken
    
    Lockbox.setString(publicKey, forKey: kPublicKey)
    Lockbox.setString(secretToken, forKey: kSecretToken)
    
    let defaults = RhymoClient.getDefaults()
    
    let data = NSKeyedArchiver.archivedDataWithRootObject(user)
    defaults.setObject(data, forKey: kUser)
  }
  
  class func getDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }
}

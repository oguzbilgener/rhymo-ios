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

let RhymoEndpoint = "http://192.168.2.254:9000/v1/" // 192.168.2.254 192.168.1.101

let kUser = "user_obj"
let kPublicKey = "public_key"
let kSecretToken = "secret_token"

let RhymoErrorDomain = NSBundle.mainBundle().bundleIdentifier!
let RhymoUnauthorizedCode = 401

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
  
  func getVenuesNearby(location: Point, result: (error: NSError?, venues: [Venue]!)->()) {
    if let user = authenticatedUser {
      let requestUrl = RhymoEndpoint + "venue/around"
      
      let parameters: [String: AnyObject] = [
        "lat": location.lat,
        "lon": location.lon
      ]

      let bodyJson = JSON(parameters)
      if let bodyStr = bodyJson.rawString(encoding: NSUTF8StringEncoding, options: NSJSONWritingOptions.allZeros) {
      
        let publicKey = user.publicKey
        let signature = RhymoClient.hmacSha1(key: user.secretToken, data: bodyStr)
        
        let queryString = "?public_key="+publicKey+"&signature="+signature
        
        let request = Alamofire.request(.POST, requestUrl + queryString, parameters: parameters, encoding: .JSON)
          .validate()
          .responseJSON {
            (request, response, data, error) in
            if(error == nil) {
              let json = JSON(data!)
              
              var venues = [Venue]()
              
              for (index: String, values: JSON) in json {
                let venue = self.parseVenue(values)
                venues.append(venue)
              }
              result(error: nil, venues: venues)
            }
            else {
              if(response?.statusCode == 401) {
                result(error: NSError(domain: RhymoErrorDomain, code: RhymoUnauthorizedCode, userInfo: nil), venues: [])
              }
              else {
                result(error: error, venues: [])
              }
            }
        }

      }
      else {
        let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
        result(error: error, venues: [])
      }
    }
    else {
      let error = NSError(domain: RhymoErrorDomain, code: 9, userInfo: nil)
      result(error: error, venues: [])
    }
  }
  
  func getVenueDetails(venueId: Int, result: (error: NSError?, venue: Venue?)->()) {
    if let user = authenticatedUser {
      let requestUrl = RhymoEndpoint + "venue/\(venueId)"
      
      let parameters: [String: AnyObject] = [
        "id": venueId
      ]
      
      let bodyJson = JSON(parameters)
      if let bodyStr = bodyJson.rawString(encoding: NSUTF8StringEncoding, options: NSJSONWritingOptions.allZeros) {
        
        let publicKey = user.publicKey
        let signature = RhymoClient.hmacSha1(key: user.secretToken, data: bodyStr)
        
        let queryString = "?public_key="+publicKey+"&signature="+signature
        
        let request = Alamofire.request(.POST, requestUrl + queryString, parameters: parameters, encoding: .JSON)
          .validate()
          .responseJSON {
            (request, response, data, error) in
            if(error == nil) {
              let json = JSON(data!)
              let venue = self.parseVenue(json)
              result(error: nil, venue: venue)
            }
            else {
              if(response?.statusCode == 401) {
                result(error: NSError(domain: RhymoErrorDomain, code: RhymoUnauthorizedCode, userInfo: nil), venue: nil)
              }
              else {
                result(error: error, venue: nil)
              }
            }
        }
      }
      else {
        let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
        result(error: error, venue: nil)
      }
    }
    else {
      let error = NSError(domain: RhymoErrorDomain, code: 9, userInfo: nil)
      result(error: error, venue: nil)
    }
  }
  
  // MARK: - Parsing helpers
  private func parseVenue(json: JSON) -> Venue {
    let venue = Venue()
    if let id = json["id"].int {
      venue.id = id
    }
    if let name = json["name"].string {
      venue.name = name
    }
    if let online = json["online"].int {
      venue.online = online == 1
    }
    if let address = json["address"].string {
      venue.address = address
    }
    if let lat = json["coord"]["lat"].double {
      venue.coord.lat = lat
    }
    if let lon = json["coord"]["lon"].double {
      venue.coord.lon = lon
    }
    if let info = json["info"].string {
      venue.info = info
    }
    var photosArray = [String]()
    for (index: String, values: JSON) in json["photos"] {
    if let photoUrl = values.string {
      photosArray.append(photoUrl)
    }
    venue.photos = photosArray
    }
    return venue
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
  
  class func hmacSha1(#key: String, data: String) -> String {
    return data.hmac(.SHA1, key: key)
  }
  
  class func getDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }
}

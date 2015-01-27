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


let HardcodedRhymoHost = "rhymo.oguzdev.com" // .114
// 192.168.2.254 192.168.1.101

let kHostname = "hostname"
let kUser = "user_obj"
let kPublicKey = "public_key"
let kSecretToken = "secret_token"
let kLogoutEnabled = "logout_enabled"
let kLoggedInEmailAddress = "logged_in_email_address"
let kFakeLocation = "DebugSettingsUseFakeLocation"

let RhymoErrorDomain = NSBundle.mainBundle().bundleIdentifier!
let RhymoUnauthorizedCode = 401
let RhymoBadRequestCode = 400

class RhymoClient {
  
  private var authenticatedUser: User?
  private var endpoint: String
  
  init() {
    endpoint = RhymoClient.getEndpoint()
    if let cachedUser = (UIApplication.sharedApplication().delegate as? AppDelegate)?.appDependencies.authenticatedUser {
      authenticatedUser = cachedUser
    }
    else {
      authenticatedUser = RhymoClient.getAuthenticatedUser()
    }
  }
  
  // MARK - Unauthenticated requests
  
  func login(#email: String, password: String, result: (NSError?, User?) -> (Void)) {
    
    let loginUrl = self.endpoint + "login"
    
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
          var user = RhymoClient.parseUser(json)
          self.storeAuthenticatedUser(user)
          
          result(nil, user)
        }
        else if(error != nil) {
          result(error, nil)
        }
        else {
          let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
          result(error, nil)
        }
    }
  }
  
  func register(#email: String, password: String, result: (NSError?, User?) -> (Void)) {
    let loginUrl = self.endpoint + "signup"
    
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
          var user = RhymoClient.parseUser(json)
          self.storeAuthenticatedUser(user)
          
          result(nil, user)
        }
        else if(error != nil) {
          result(error, nil)
        }
        else {
          let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
          result(error, nil)
        }
    }
  }
  
  func logout() {
    let defaults = RhymoClient.getDefaults()
    
    defaults.removeObjectForKey(kUser)
    defaults.removeObjectForKey(kLoggedInEmailAddress)
    
    self.authenticatedUser = nil
  }
  
  // MARK: - Authenticated requests
  
  func getVenuesNearby(location: Point, result: (error: NSError?, venues: [Venue]!)->()) {
    if let user = authenticatedUser {
      let requestUrl = self.endpoint + "venue/around"
      
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
              if (data != nil) {
                let json = JSON(data!)
                
                var venues = [Venue]()
                
                for (index: String, values: JSON) in json {
                  let venue = RhymoClient.parseVenue(values)
                  venues.append(venue)
                }
                result(error: nil, venues: venues)
              }
              else {
               result(error: nil, venues: [Venue]())
              }
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
      let requestUrl = self.endpoint + "venue/\(venueId)"
      
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
              if (data != nil) {
                let json = JSON(data!)
                let venue = RhymoClient.parseVenue(json)
                result(error: nil, venue: venue)
              }
              else {
                result(error: nil, venue: nil)
              }
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
  
  func getTracksByName(keyword: String, venueId: Int, result: (error: NSError?, tracks: [Track])->()) -> Request? {
    if let user = authenticatedUser {
      var orepStr = keyword.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
      var repStr = ""
      if let encodedKeyword = orepStr {
        repStr = encodedKeyword
      }
      let requestUrl = self.endpoint + "search/tracks"
      let parameters: [String: AnyObject] = [
        "query": keyword,
        "venue_id": venueId
      ]
      
      let bodyJson = JSON(parameters)
      if let bodyStr = bodyJson.rawString(encoding: NSUTF8StringEncoding, options: NSJSONWritingOptions.allZeros) {
        
        let publicKey = user.publicKey
        let signature = RhymoClient.hmacSha1(key: user.secretToken, data: bodyStr)
        
        let queryString = "?public_key="+publicKey+"&signature="+signature

        let request = Alamofire.request(.POST, requestUrl + queryString, parameters: parameters, encoding: .JSON)
//          .validate()
          .responseJSON {
            (request, response, data, error) in
            if(error == nil) {
              if (data != nil) {
                let json = JSON(data!)
                var tracks = [Track]()
                
                for (index: String, values: JSON) in json {
                  let track = RhymoClient.parseTrack(values)
                  tracks.append(track)
                }
                
                result(error: nil, tracks: tracks)
              }
              else {
                result(error: nil, tracks: [Track]())
              }
            }
            else {
              if(response?.statusCode == 401) {
                result(error: NSError(domain: RhymoErrorDomain, code: RhymoUnauthorizedCode, userInfo: nil), tracks: [Track]())
              }
              else {
                result(error: error, tracks: [Track]())
              }
            }
        }
        return request
      }
      else {
        let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
        result(error: error, tracks: [Track]())
      }
    }
    else {
      let error = NSError(domain: RhymoErrorDomain, code: 9, userInfo: nil)
      result(error: error, tracks: [Track]())
    }
    return nil
  }
  
  func requestTrack(#track: Track, venue: Venue, result: (error: NSError?, success: Bool, reason: String) -> ()) {
    if let user = authenticatedUser {
      let requestUrl = self.endpoint + "request"
      
      let parameters: [String: AnyObject] = [
        "venue_id": venue.id,
        "track_id": track.fizyId
      ]
      
      let bodyJson = JSON(parameters)
      if let bodyStr = bodyJson.rawString(encoding: NSUTF8StringEncoding, options: NSJSONWritingOptions.allZeros) {
        
        let publicKey = user.publicKey
        let signature = RhymoClient.hmacSha1(key: user.secretToken, data: bodyStr)
        
        let queryString = "?public_key="+publicKey+"&signature="+signature
        
        println(requestUrl + queryString)
        println(bodyStr)
        
        let request = Alamofire.request(.POST, requestUrl + queryString, parameters: parameters, encoding: .JSON)
          .responseJSON {
            (request, response, data, error) in
            if(error == nil && response?.statusCode == 200) {
              // 200 = request is successful
              if (data != nil) {
                let json = JSON(data!)
                println(json)
                result(error: nil, success: true, reason: "")
              }
              else {
//                result(error: nil, success: true)
                println("data null?")
              }
            }
            else {
              if(response?.statusCode == 400) {
                if(data != nil) {
                  let json = JSON(data!)
                  let reason = json["reason"].stringValue
                  result(error: NSError(domain: RhymoErrorDomain, code: RhymoBadRequestCode, userInfo: nil), success: false, reason: reason)
                }
                else {
                  result(error: NSError(domain: RhymoErrorDomain, code: RhymoBadRequestCode, userInfo: nil), success: false, reason: "")
                }
              }
              if(response?.statusCode == 401) {
                result(error: NSError(domain: RhymoErrorDomain, code: RhymoUnauthorizedCode, userInfo: nil), success: false, reason: "unauthorized")
              }
              else {
                result(error: error, success: false, reason: "")
              }
            }
        }
      }
      else {
        let error = NSError(domain: RhymoErrorDomain, code: 11, userInfo: nil)
        result(error: error, success: false, reason: "")
      }

    }
    else {
      let error = NSError(domain: RhymoErrorDomain, code: 9, userInfo: nil)
      result(error: error, success: false, reason: "")
    }
  }
  
  // MARK: - Parsing helpers
  
  class func parseUser(json: JSON) -> User {
    let user = User()
    
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

    return user
  }
  
  class func parseVenue(json: JSON) -> Venue {
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
    venue.nowPlaying = RhymoClient.parsePlaylistTrack(json["now_playing"])
    var photosArray = [String]()
    for (index: String, values: JSON) in json["photos"] {
    if let photoUrl = values.string {
      photosArray.append(photoUrl)
    }
    venue.photos = photosArray
    }
    return venue
  }
  
  class func parseTrack(json: JSON) -> Track {
    let track = Track()
    if let albumName = json["album"]["name"].string {
      track.albumName = albumName
    }
    if let coverUrl = json["album"]["cover_large"].string {
      track.albumCoverUrl = coverUrl
    }
    if let artistName = json["artist"]["name"].string {
      track.artistName = artistName
    }
    if let name = json["name"].string {
      track.name = name
    }
    if let duration = json["duration"].int {
      track.duration = duration
    }
    if let id = json["id"].int {
      track.fizyId = id
    }
    return track
  }
  
  class func parsePlaylistTrack(json: JSON) -> PlaylistTrack {
    let track = PlaylistTrack()
    if let albumName = json["album"]["name"].string {
      track.albumName = albumName
    }
    if let coverUrl = json["album"]["cover_large"].string {
      track.albumCoverUrl = coverUrl
    }
    if let artistName = json["artist"]["name"].string {
      track.artistName = artistName
    }
    if let name = json["name"].string {
      track.name = name
    }
    if let duration = json["duration"].int {
      track.duration = duration
    }
    if let id = json["id"].int {
      track.fizyId = id
    }
    if let playBegan = json["play_began"].int {
      track.playBegan = playBegan
    }
    if let playEnded = json["play_ended"].int {
      track.playEnded = playEnded
    }
    if let storeId = json["store_id"].int {
      track.storeId = storeId
    }
    return track
  }
  
  class func fakeLocationEnabled() -> Bool {
    return getDefaults().boolForKey(kFakeLocation)
  }
  
  // MARK: - Authentication helpers

  class func getAuthenticatedUser() -> User? {
    
    let defaults = RhymoClient.getDefaults()
    
    if let logout_enabled = defaults.objectForKey(kLogoutEnabled) as? Bool {
      defaults.removeObjectForKey(kLogoutEnabled)
      (RhymoClient()).logout()
      return nil
    }
    
    // get the user object from an unencrypted data store
    if let data = defaults.objectForKey(kUser) as? NSData {
      let user = NSKeyedUnarchiver.unarchiveObjectWithData(data) as User
//      // fill the public key and secret token from an encrypted data store
//      if let publicKey = defaults.stringForKey(kPublicKey) {
//        user.publicKey = publicKey
//      }
//      if let secretToken = defaults.stringForKey(kSecretToken) {
//        user.secretToken = secretToken
//      }

      
      return user
    }
    return nil
  }
  
  private func storeAuthenticatedUser(user: User) {
    
    let defaults = RhymoClient.getDefaults()

    
    let data = NSKeyedArchiver.archivedDataWithRootObject(user)
    defaults.setObject(data, forKey: kUser)
    defaults.setObject(user.email, forKey: kLoggedInEmailAddress)
  }
  
  class func getEndpoint() -> String {
    return "http://" + RhymoClient.retrievePreferredHostname() + "/v1/"
  }
  
  class func retrievePreferredHostname() -> String {
    if let hostname = RhymoClient.getDefaults().stringForKey(kHostname) {
      if(hostname != "") {
        return hostname
      }
    }
    return HardcodedRhymoHost
  }
  
  class func storePreferredHostname(hostname: String) {
    getDefaults().setObject(hostname, forKey: kHostname)
  }
  
  class func hmacSha1(#key: String, data: String) -> String {
    return data.hmac(.SHA1, key: key)
  }
  
  class func getDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }
}

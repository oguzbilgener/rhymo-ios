//
//  User.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
  
  var id: Int = 0
  var userName: String = ""
  var email: String = ""
  var password: String = ""
  var publicKey: String = ""
  var secretToken: String = ""
  var profilePic : String = ""
  var birthday: String = ""
  
  override init() {
    super.init()
  }
  
  required init(coder decoder: NSCoder) {
    id = decoder.decodeIntegerForKey("id")
    userName = decoder.decodeObjectForKey("userName") as! String
    email = decoder.decodeObjectForKey("email") as! String
    password = decoder.decodeObjectForKey("password") as! String
    publicKey = decoder.decodeObjectForKey("publicKey") as! String
    secretToken = decoder.decodeObjectForKey("secretToken") as! String
    profilePic = decoder.decodeObjectForKey("profilePic") as! String
    birthday = decoder.decodeObjectForKey("birthday") as! String
  }
  
  func encodeWithCoder(encoder: NSCoder) {
    encoder.encodeInteger(id, forKey: "id")
    encoder.encodeObject(userName, forKey: "userName")
    encoder.encodeObject(email, forKey: "email")
    encoder.encodeObject(password, forKey: "password")
    encoder.encodeObject(publicKey, forKey: "publicKey")
    encoder.encodeObject(secretToken, forKey: "secretToken")
    encoder.encodeObject(profilePic, forKey: "profilePic")
    encoder.encodeObject(birthday, forKey: "birthday")
  }
  
}

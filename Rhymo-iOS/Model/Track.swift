//
//  Track.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class Track: NSObject {
  
  var fizyId: Int
  var name: String
  var artistName: String
  var albumName: String
  var secureUrl: String
  var albumCoverUrl: String
  
  var duration: Int
  
  override init() {
    fizyId = 0
    name = ""
    artistName = ""
    albumName = ""
    secureUrl = ""
    albumCoverUrl = ""
    duration = 0
  }
  
  override var description: String {
    return "\(name) by \(artistName) (\(fizyId))"
  }
   
}

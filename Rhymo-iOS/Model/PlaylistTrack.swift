//
//  PlaylistTrack.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class PlaylistTrack: Track {
  var storeId: Int
  var playBegan: Int
  var playEnded: Int
  
  override init() {
    storeId = 0
    playBegan = 0
    playEnded = 0
    super.init()
  }
}

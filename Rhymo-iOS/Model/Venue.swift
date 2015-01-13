//
//  Venue.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 13/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class Venue: NSObject, Printable {
  
  var id: Int = 0
  var name: String = ""
  var address: String = ""
  var online: Bool = false
  var photos: [String] = []
  var coord: Point = Point()
  var info: String = ""
  var genres: [String] = []
  
  override var description: String {
    return "\(name) at \(coord)"
  }
}

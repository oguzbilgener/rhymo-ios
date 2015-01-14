//
//  Point.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 13/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import CoreLocation

class Point: NSObject, Printable {
  
  var lat: Double = 0
  var lon: Double = 0
  
  override init() {
    lat = 0
    lon = 0
  }
  
  init(point: Point) {
    lat = point.lat
    lon = point.lon
  }
  
  init(location: CLLocation) {
    lat = location.coordinate.latitude
    lon = location.coordinate.longitude
  }
  
  override var description: String {
    return "\(lat), \(lon)"
  }
}

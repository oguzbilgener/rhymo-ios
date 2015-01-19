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
  var nowPlaying: PlaylistTrack = PlaylistTrack()
  
  override init() {
    
  }
  
  init(venue: Venue) {
    // TODO: make real deep copy
    id = venue.id
    name = venue.name
    address = venue.address
    online = venue.online
    photos = venue.photos
    coord = Point(point: venue.coord)
    info = venue.info
    genres = venue.genres
    nowPlaying = venue.nowPlaying
  }
  
  override var description: String {
    return "\(name) at \(coord)"
  }
}

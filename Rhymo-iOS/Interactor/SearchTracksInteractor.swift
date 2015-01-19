//
//  SearchTracksInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import Alamofire

let TrackSearchMinimumLength = 3

class SearchTracksInteractor: BaseInteractor {
  
  var output: SearchTracksPresenter?
  var lastSearchRequestDate = NSDate()
  var lastSearchRequest: Request?
  let minSearchInterval = 0.3
  
  func getTracksByName(name: String, venueId: Int, result:(error: NSError?, tracks: [Track])->()) {
    if(countElements(name) == 0) {
      output?.clearTracksList()
      return
    }
    if(countElements(name) < TrackSearchMinimumLength) {
      // keyword is too short yet. return without sending any callbacks
      return
    }
    if let last = lastSearchRequest {
      if((NSDate().timeIntervalSince1970 - lastSearchRequestDate.timeIntervalSince1970) < minSearchInterval) {
        last.cancel()
      }
    }
    lastSearchRequestDate = NSDate()
    let client = RhymoClient()
    client.getTracksByName(name, venueId: venueId, result: result)
  }
   
}

//
//  SearchTracksInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let TrackSearchMinimumLength = 3

class SearchTracksInteractor: BaseInteractor {
  
  var output: SearchTracksPresenter?
  
  func getTracksByName(name: String, result:(error: NSError?, tracks: [Track])->()) {
    if(countElements(name) < TrackSearchMinimumLength) {
      // keyword is too short yet. return without sending any callbacks
      return
    }
    let client = RhymoClient()
    client.getTracksByName(name, result: result)
  }
   
}

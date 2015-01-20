//
//  RequestConfirmInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class RequestConfirmInteractor: BaseInteractor {
  
  var output: RequestConfirmPresenter?
  
  func sendTrackRequest(venue: Venue, track: Track, result: (error: NSError?, success: Bool, reason: String)->()) {
    let client = RhymoClient()
    client.requestTrack(track: track, venue: venue, result: result)
  }
}

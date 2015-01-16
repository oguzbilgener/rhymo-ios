//
//  VenueDetailsInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsInteractor: BaseInteractor {
  
  var output: VenueDetailsPresenter?
  
  func getVenueDetails(venueId: Int, result: (error: NSError?, venue: Venue?) -> ()) {
    let client = RhymoClient()
    client.getVenueDetails(venueId, result: result)
  }
}

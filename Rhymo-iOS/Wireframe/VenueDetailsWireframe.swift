//
//  VenueDetailsWireframe.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueDetailsWireframe: BaseWireframe {
  
  var venueDetailsInteractor: VenueDetailsInteractor?
  var venueDetailsPresenter: VenueDetailsPresenter?
  var venue = Venue()
  
//  override init() {
//    
//  }
  
  func configureDependencies(window: UIWindow, viewController: VenueDetailsViewController?) {
    venueDetailsInteractor = VenueDetailsInteractor()
    venueDetailsPresenter = VenueDetailsPresenter()
    
    venueDetailsInteractor?.output = venueDetailsPresenter
    
    venueDetailsPresenter?.venueDetailsInteractor = venueDetailsInteractor
    venueDetailsPresenter?.venueDetailsWireframe = self
    
    if let userInterface = viewController? {
      userInterface.eventHandler = venueDetailsPresenter
      venueDetailsPresenter?.userInterface = userInterface
    }
  }
  
}

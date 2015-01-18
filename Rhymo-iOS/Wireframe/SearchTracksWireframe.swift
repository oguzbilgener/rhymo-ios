//
//  SearchTracksWireframe
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SearchTracksWireframe: BaseWireframe {
  
  var requestConfirmWireframe: RequestConfirmWireframe?
  
  var searchTracksInteractor: SearchTracksInteractor?
  var searchTracksPresenter: SearchTracksPresenter?
  var venue = Venue()
  
  func configureDependencies(window: UIWindow, viewController: SearchTracksViewController?) {
    searchTracksInteractor = SearchTracksInteractor()
    searchTracksPresenter = SearchTracksPresenter()
    
    searchTracksInteractor?.output = searchTracksPresenter
    
    searchTracksPresenter?.searchTracksInteractor = searchTracksInteractor
    searchTracksPresenter?.searchTracksWireframe = self
    
    if let userInterface = viewController? {
      userInterface.eventHandler = searchTracksPresenter
      searchTracksPresenter?.userInterface = userInterface
    }
    
    requestConfirmWireframe = RequestConfirmWireframe()
  }
  
  func passVenueAndTrackToDetails(#track: Track) {
    requestConfirmWireframe?.venue = venue
    requestConfirmWireframe?.track = track
  }
  
}

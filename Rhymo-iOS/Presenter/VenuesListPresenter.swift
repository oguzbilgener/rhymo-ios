//
//  VenuesListPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenuesListPresenter: BasePresenter {
  
  var venuesListInteractor: VenuesListInteractor?
  var venuesListWireframe: HomeWireframe?
  
  var userInterface: VenuesListViewController?
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
  }
}

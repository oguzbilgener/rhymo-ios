//
//  RequestConfirmViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class RequestConfirmWireframe: BaseWireframe {
  
  var requestConfirmInteractor: RequestConfirmInteractor?
  var requestConfirmPresenter: RequestConfirmPresenter?
  var venue = Venue()
  var track = Track()
  
  func configureDependencies(window: UIWindow, viewController: RequestConfirmViewController?) {
    requestConfirmPresenter = RequestConfirmPresenter()
    requestConfirmInteractor = RequestConfirmInteractor()
    
    requestConfirmInteractor?.output = requestConfirmPresenter
    
    requestConfirmPresenter?.requestConfirmInteractor = requestConfirmInteractor
    requestConfirmPresenter?.requestConfirmWireframe = self
    
    if let userInterface = viewController? {
      userInterface.eventHandler = requestConfirmPresenter
      requestConfirmPresenter?.userInterface = userInterface
    }
  }
}

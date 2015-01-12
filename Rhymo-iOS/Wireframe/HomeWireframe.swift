//
//  HomeWireframe.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let HomeViewControllerIdentifier = "HomeViewController"

class HomeWireframe: BaseWireframe {
  
  var venuesListInteractor: VenuesListInteractor?
  var venuesListPresenter: VenuesListPresenter?
  
  func presentHomeInterfaceFromWindow(window: UIWindow) {
    window.rootViewController = homeViewControllerFromStoryboard()
  }
  
  func homeViewControllerFromStoryboard() -> HomeViewController {
    return mainStoryboard().instantiateViewControllerWithIdentifier(HomeViewControllerIdentifier) as HomeViewController
  }
  
  func configureDependencies(window: UIWindow) {
    venuesListInteractor = VenuesListInteractor()
    venuesListPresenter = VenuesListPresenter()
    
    venuesListInteractor?.output = venuesListPresenter
    
    venuesListPresenter?.venuesListInteractor = venuesListInteractor
    venuesListPresenter?.venuesListWireframe = self
    
    let navigationViewController = window.rootViewController as UINavigationController

    let venuesListViewController = navigationViewController.viewControllers[0] as VenuesListViewController
    venuesListViewController.eventHandler = venuesListPresenter
    venuesListPresenter?.userInterface = venuesListViewController
  }
}

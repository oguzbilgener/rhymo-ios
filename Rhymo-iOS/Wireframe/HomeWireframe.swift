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
  
  func presentHomeInterfaceFromWindow(window: UIWindow) {
    window.rootViewController = homeViewControllerFromStoryboard()
  }
  
  func homeViewControllerFromStoryboard() -> HomeViewController {
    return mainStoryboard().instantiateViewControllerWithIdentifier(HomeViewControllerIdentifier) as HomeViewController
  }
}

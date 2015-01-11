//
//  BaseWireframe.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class BaseWireframe {
  
  func mainStoryboard() -> UIStoryboard {
    let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    return storyboard
  }
}

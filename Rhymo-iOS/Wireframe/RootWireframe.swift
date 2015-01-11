//
//  RootWireframe.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class RootWireframe {
  
  var authWireframe: AuthWireframe?
  var homeWireframe: HomeWireframe?
  
  init() {
    
  }
  
  init(authWireframe: AuthWireframe, homeWireframe: HomeWireframe) {
    self.authWireframe = authWireframe
    self.homeWireframe = homeWireframe
  }
   
}

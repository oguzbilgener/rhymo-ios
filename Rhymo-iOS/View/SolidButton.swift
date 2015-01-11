//
//  SolidButton.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SolidButton: UIButton {
  
  required init(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    
    self.layer.cornerRadius = 5.0;
    
    self.layer.borderColor = UIColor.whiteColor().CGColor
    
    self.layer.borderWidth = 1
    
    self.backgroundColor = UIColor.clearColor()
    
    self.tintColor = UIColor.whiteColor()

    
  }
  
//  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//    super.touchesBegan(touches, withEvent: event)
//    self.layer.borderColor = self.currentTitleColor!.CGColor
//  }
//  
//  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
//    super.touchesEnded(touches, withEvent: event)
//
//    self.layer.borderColor = self.currentTitleColor!.CGColor
//  }
//  
//  override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
//    super.touchesEnded(touches, withEvent: event)
//    
//    self.layer.borderColor = self.currentTitleColor!.CGColor
//  }
  

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

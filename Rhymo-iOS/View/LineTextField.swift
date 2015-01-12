//
//  LineTextView.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 12/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class LineTextField: UITextField {

  
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//
//      let currentContext = UIGraphicsGetCurrentContext()
//      let line = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - 2, rect.size.width, 1)
//      let color = UIColor.blueColor().CGColor
//      
//      CGContextSetFillColorWithColor(currentContext, color)
//      CGContextFillRect(currentContext, rect)
//      
//      super.drawRect(rect)
//    }

  
  required init(coder aDecoder: NSCoder) {
    
    super.init(coder: aDecoder)
    
    self.borderStyle = UITextBorderStyle.None
    
    self.layer.cornerRadius = 0;
    
    self.layer.borderColor = UIColor.whiteColor().CGColor
    
    self.layer.borderWidth = 0
    
    self.backgroundColor = UIColor.clearColor()
    
    self.tintColor = UIColor.whiteColor()
    
    let bgLayer = CALayer()
    let bounds = self.bounds
    let frame = self.frame
    bgLayer.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.bounds.size.height - 2, self.bounds.size.width, 1)
    bgLayer.backgroundColor = UIColor(white: 1, alpha: 0.8).CGColor
    
//    self.layer.addSublayer(bgLayer)
    
    
  }

}

//
//  SolidButton.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 11/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SolidButton: UIButton {
  
  // primary color: text and border color when button is in normal state, background color when button is in highlighted state
  var primaryColor: UIColor = UIColor.whiteColor()
  // secondary color: background color when button is in normal state, text color when button is in highlighted state
  var secondaryColor: UIColor = UIColor.blackColor()
  
  var bglayer: CALayer?
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    if let color = self.titleColorForState(UIControlState.Normal) {
      self.primaryColor = color
    }
    self.secondaryColor = UIColor(CGColor: self.layer.backgroundColor)
    
    configurateToDefault()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configurateToDefault()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    if let color = self.titleColorForState(UIControlState.Normal) {
      self.primaryColor = color
    }
    self.secondaryColor = UIColor(CGColor: self.layer.backgroundColor)
    
    configurateToDefault()
    // Initialization code
  }
  
  func configurateToDefault() {
    self.setTitleColor(self.primaryColor, forState: UIControlState.Normal)
    self.setTitleColor(self.secondaryColor, forState: UIControlState.Highlighted)
    self.setTitleColor(self.secondaryColor, forState: UIControlState.Selected)
    
    self.layer.cornerRadius = 5.0
    
    self.layer.borderColor = self.primaryColor.CGColor
    
    self.layer.borderWidth = 1
    
    self.backgroundColor = self.secondaryColor
    
    self.tintColor = UIColor.whiteColor()
  }
  
  override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
//    self.layer.borderColor = UIColor(rgba: "#000000").CGColor //self.currentTitleColor!.CGColor
    self.layer.borderColor = self.primaryColor.CGColor
//    self.layer.backgroundColor = self.primaryColor.CGColor
    
//    self.bglayer = makeTextLayer()
    
//    self.layer.addSublayer(bglayer)
    
//    let lay = CALayer()
//    lay.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//    lay.backgroundColor = UIColor.whiteColor().CGColor
//    self.layer.mask = lay
    
    self.setNeedsDisplay()
  }
  
  override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
//    self.layer.borderColor = UIColor.blueColor().CGColor//self.currentTitleColor!.CGColor
    self.layer.borderColor = self.primaryColor.CGColor
//    self.layer.backgroundColor = self.secondaryColor.CGColor
    
//    self.titleLabel?.hidden = false
    
//    self.bglayer?.removeFromSuperlayer()
//    self.layer.mask = nil
    
    self.setNeedsDisplay()
  }
  
  override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
    super.touchesEnded(touches, withEvent: event)
//    self.layer.borderColor = UIColor.greenColor().CGColor//self.currentTitleColor!.CGColor
    self.layer.borderColor = self.primaryColor.CGColor
//    self.layer.backgroundColor = self.secondaryColor.CGColor
    
//    self.layer.mask = nil
//    
//    self.bglayer?.removeFromSuperlayer()
//    self.titleLabel?.hidden = false
    
    self.setNeedsDisplay()
  }
  
  func makeTextLayer() -> CATextLayer {
    var layer = CATextLayer()
//    debugPrintln(self.bounds)
//    debugPrintln(self.frame)
//    if let label = self.titleLabel {
//      debugPrintln(label.frame)
//      layer.bounds = label.bounds
//    }
    let font = self.titleLabel!.font!
    let str = self.titleLabel!.text!
    let rect = self.titleLabel!.bounds
    
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    // Flip the coordinate system
    UIColor.darkGrayColor().setFill()
    CGContextFillRect(context, rect)
    CGContextSaveGState(context)
    UIColor.whiteColor().setFill()
    CGContextTranslateCTM(context, 0, rect.size.height)
    CGContextScaleCTM(context, 1.0, -1.0)
    
    NSString(string: str).drawInRect(rect, withAttributes: [NSFontAttributeName: font])
    CGContextRestoreGState(context)
    let alphaMask = CGBitmapContextCreateImage(context)
    UIColor.whiteColor().setFill()
    CGContextFillRect(context, rect)
    CGContextSaveGState(context)
    CGContextClipToMask(context, rect, alphaMask)
    CGContextRestoreGState(context)
    
    
    let img = UIGraphicsGetImageFromCurrentImageContext()
    layer.contents = img
    
    
//    layer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//    layer.backgroundColor = UIColor.whiteColor().CGColor
//    layer.foregroundColor = UIColor.blackColor().CGColor
//    layer.string = self.titleLabel?.text
//    layer.font = self.titleLabel?.font
//    layer.alignmentMode = kCAAlignmentNatural
//    layer.wrapped = true
    return layer
  }
  

//  
//    override func drawRect(rect: CGRect) {
//      super.drawRect(rect)
//      
//
//      let font = self.titleLabel!.font!
//      let str = self.titleLabel!.text!
//      let rect = self.titleLabel!.bounds
//      
//      let context = UIGraphicsGetCurrentContext()
//      
//      CGContextClearRect(context, self.bounds)
//      
//      secondaryColor.set()
//      
//      let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
//      path.lineWidth = 2
//      path.stroke()
//      path.fill()
//      
//      CGContextSetBlendMode(context, kCGBlendModeClear)
//      
//      var str2 = NSString(string: str)
////      str2.drawInRect(rect, withAttributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: secondaryColor])
//    }
//  

}

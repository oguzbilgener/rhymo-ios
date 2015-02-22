//
//  VenueSuggestionView.swift
//  Rhymo
//
//  Created by Oguz Bilgener on 22/02/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueSuggestionView: UIView {
  
  var displayedVenue: Venue?
  var displayLabel: UILabel?
  
  let defaultBackgroundColor = UIColor(rgba: "#00000088")
  let touchBackgroundColor = UIColor(rgba: "#00000055")
  let textColor = UIColor.whiteColor()
  
  init(venue: Venue) {
    super.init(frame: CGRectZero)
    displayedVenue = venue
    
    let text = VenueSuggestionView.makeDisplayText(venue)
    displayLabel = UILabel()
    displayLabel!.attributedText = text
    
    self.addSubview(displayLabel!)
    
    self.backgroundColor = defaultBackgroundColor
    displayLabel!.textColor = textColor
    
    self.setupConstraints()
    
  }
  
  func setupConstraints() {
    displayLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.addConstraint(NSLayoutConstraint(item: displayLabel!, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: displayLabel!, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item:displayLabel!, attribute: .Width, relatedBy: .LessThanOrEqual, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesBegan(touches, withEvent: withEvent)
    self.backgroundColor = touchBackgroundColor
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesEnded(touches, withEvent: withEvent)
    self.backgroundColor = defaultBackgroundColor
  }
  
  override func touchesCancelled(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesCancelled(touches, withEvent: withEvent)
    self.backgroundColor = defaultBackgroundColor
  }
  
  static func makeDisplayText(venue: Venue) -> NSAttributedString {
    let venueInfoNormalFont = UIFont.systemFontOfSize(17)
    let venueInfoBoldFont = UIFont.boldSystemFontOfSize(17)
    
    let normalFontAttrs = [NSFontAttributeName: venueInfoNormalFont]
    let boldFontAttrs = [NSFontAttributeName: venueInfoBoldFont]
    
    let complement = "Looks like you're at "
    let wholeString = complement + venue.name
    let displayString = NSMutableAttributedString(string: wholeString, attributes: normalFontAttrs)
    displayString.setAttributes(boldFontAttrs, range: NSMakeRange(count(complement), count(venue.name)))
    
    return displayString
  }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

//
//  VenueCell.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKIt

class VenueCell: UITableViewCell {
  
  @IBOutlet weak var venueTitle: UILabel!
  @IBOutlet weak var venueAddress: UILabel!
  
  @IBOutlet weak var iconOnline: UIImageView!
  @IBOutlet weak var iconOffline: UIImageView!
  
  override func touchesBegan(touches: NSSet, withEvent: UIEvent) {
    super.touchesBegan(touches, withEvent: withEvent)
    self.backgroundColor = accentColor
  }
  
  override func touchesEnded(touches: NSSet, withEvent: UIEvent) {
    super.touchesEnded(touches, withEvent: withEvent)
    self.backgroundColor = UIColor.clearColor()
  }
  
  override func touchesCancelled(touches: NSSet, withEvent: UIEvent) {
    super.touchesCancelled(touches, withEvent: withEvent)
    self.backgroundColor = UIColor.clearColor()
  }

}

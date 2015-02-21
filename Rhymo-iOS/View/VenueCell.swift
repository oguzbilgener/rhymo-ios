//
//  VenueCell.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class VenueCell: UITableViewCell {
  
  @IBOutlet weak var venueTitle: UILabel!
  @IBOutlet weak var venueAddress: UILabel!
  
  @IBOutlet weak var iconOnline: UIImageView!
  @IBOutlet weak var iconOffline: UIImageView!
  
  override func touchesBegan(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesBegan(touches, withEvent: withEvent)
    self.backgroundColor = accentColor
  }
  
  override func touchesEnded(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesEnded(touches, withEvent: withEvent)
    self.backgroundColor = contentBackgroundColor
  }
  
  override func touchesCancelled(touches: Set<NSObject>, withEvent: UIEvent) {
    super.touchesCancelled(touches, withEvent: withEvent)
    self.backgroundColor = contentBackgroundColor
  }

}

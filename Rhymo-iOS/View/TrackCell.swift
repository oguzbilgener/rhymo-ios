//
//  TrackCell.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 17/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
  
  @IBOutlet weak var albumArtView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var artistLabel: UILabel!
  
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

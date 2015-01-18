//
//  SearchTrackCell.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SearchTrackCell: UITableViewCell {


  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var trackArtistLabel: UILabel!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  override func touchesBegan(touches: NSSet, withEvent: UIEvent) {
    super.touchesBegan(touches, withEvent: withEvent)
    self.backgroundColor = accentColor
  }
  
  override func touchesEnded(touches: NSSet, withEvent: UIEvent) {
    super.touchesEnded(touches, withEvent: withEvent)
    self.backgroundColor = contentBackgroundColor
  }
  
  override func touchesCancelled(touches: NSSet, withEvent: UIEvent) {
    super.touchesCancelled(touches, withEvent: withEvent)
    self.backgroundColor = contentBackgroundColor
  }

}

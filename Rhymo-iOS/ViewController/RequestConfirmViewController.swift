//
//  RequestConfirmViewController.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class RequestConfirmViewController: BaseViewController {
  
  var eventHandler: RequestConfirmPresenter?
  
  var customNavigationBar: UINavigationBar?
  var customNavigationItem: UINavigationItem?
  
  
  @IBOutlet weak var chosenTrackCoverView: UIImageView!
  @IBOutlet weak var chosenTrackNameLabel: UILabel!
  @IBOutlet weak var chosenTrackArtistLabel: UILabel!
  @IBOutlet weak var chosenTrackAlbumLabel: UILabel!
  
  @IBOutlet weak var playConfirmButton: UIButton!
  @IBOutlet weak var venueDisplayMap: MKMapView!
  
  @IBOutlet weak var venueDisplayLabel: UILabel!
  @IBOutlet weak var addressDisplayLabel: UILabel!
  
  let imageManager = SDWebImageManager.sharedManager()
  

  override func viewDidLoad() {
    super.viewDidLoad()
    // define custom nav bar
    let originalBarFrame = self.navigationController!.navigationBar.frame
    let customBarFrame = CGRect(x: 0, y: 20, width: originalBarFrame.size.width, height: originalBarFrame.size.height)
    customNavigationBar = UINavigationBar(frame: customBarFrame)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    customNavigationBar!.barTintColor = UIColor(hue:0.98, saturation:0.8, brightness:0.79, alpha:1)
    customNavigationBar!.translucent = false
    customNavigationItem = UINavigationItem()
    customNavigationItem!.title = "Play a song"
    customNavigationBar!.setItems([customNavigationItem!], animated: false)
    customNavigationBar!.titleTextAttributes = [NSForegroundColorAttributeName: textOnPrimaryColor]
    // Manually set a back bar ittem
    let backItem = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: eventHandler, action: "backPressed:")
    customNavigationItem!.leftBarButtonItem = backItem
    self.view.addSubview(customNavigationBar!)
    
    // TODO: fix this titlebg with AutoLayout, make it disappear when the screen is landscape
    let titlebg = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height, height: 20))
    titlebg.backgroundColor = UIColor(hue:0.98, saturation:0.8, brightness:0.79, alpha:1)
    self.view.addSubview(titlebg)
    titlebg.setTranslatesAutoresizingMaskIntoConstraints(false)
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
    self.view.addConstraint(NSLayoutConstraint(item: titlebg, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20))
    
    eventHandler?.onViewLoadFinish()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    
  }
  
  // MARK: - UI Setup
  
  func displayChosenTrack(track: Track) {
    chosenTrackNameLabel.text = track.name
    chosenTrackArtistLabel.text = track.artistName
    chosenTrackAlbumLabel.text = track.albumName
    
    if(track.albumCoverUrl != "") {
      let url = NSURL(string: track.albumCoverUrl)
      imageManager.downloadImageWithURL(url, options: SDWebImageOptions.allZeros, progress: { (receivedSize: Int, expectedSize: Int) -> Void in
        }) { (image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
          if(finished) {
            UIView.transitionWithView(self.chosenTrackCoverView, duration: VenueDetailsAnimationDuration, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () in
              self.chosenTrackCoverView.image = image
              }, completion: nil)
          }
      }
    }
  }
  
  func displayVenueDetails(venue: Venue) {
    let venueInfoNormalFont = UIFont.systemFontOfSize(17)
    let venueInfoBoldFont = UIFont.boldSystemFontOfSize(17)
    
    let normalFontAttrs = [NSFontAttributeName: venueInfoNormalFont]
    let boldFontAttrs = [NSFontAttributeName: venueInfoBoldFont]
    
    let complement = "You are at "
    let infoString = complement + venue.name
    
    var venueInfoString = NSMutableAttributedString(string: infoString, attributes: normalFontAttrs)
    venueInfoString.setAttributes(boldFontAttrs, range: NSMakeRange(countElements(complement), countElements(venue.name)))
    
    venueDisplayLabel.attributedText = venueInfoString
    
    // TODO: make a better representation for address
    addressDisplayLabel.text = venue.address
    
    self.updateMap(venue)
  }
  
  func displayPurchaseButton(#value: Double, currency: String, verb: String) {
    var titleStr = ""
    if(value == 0) {
      titleStr = verb
    }
    else {
      titleStr = String(format: "%.2f %s %s", value, currency, verb)
    }
    playConfirmButton.setTitle(verb, forState: UIControlState.Normal)
    playConfirmButton.setTitle(verb, forState: UIControlState.Highlighted)
    playConfirmButton.setTitle(verb, forState: UIControlState.Disabled)

    let buttonColor = UIColor(rgba: "#63A345")

    playConfirmButton.setTitleColor(buttonColor, forState: .Normal)
    playConfirmButton.setTitleColor(buttonColor, forState: .Highlighted)
    playConfirmButton.setTitleColor(buttonColor, forState: .Disabled)
    
    playConfirmButton.layer.borderColor = buttonColor.CGColor
    
    playConfirmButton.hidden = false
  }
  
  func hidePurchaseButton() {
    playConfirmButton.hidden = true
  }
  
  func updateMap(venue: Venue) {
    let region = MKCoordinateRegionMakeWithDistance(venue.coord.asCoordinate, 300, 300)
    venueDisplayMap.region = region
    
    
    venueDisplayMap.removeAnnotations(venueDisplayMap.annotations)
    let annotation = MKPointAnnotation()
    annotation.coordinate = venue.coord.asCoordinate
    annotation.title = venue.name
    venueDisplayMap.addAnnotation(annotation)
  }
  
  
  @IBAction func playConfirmButtonTouched(sender: UIButton) {
//    eventHandler?.playConfirmButtonTouched(sender: UIButton)
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return UIStatusBarStyle.LightContent
  }
}

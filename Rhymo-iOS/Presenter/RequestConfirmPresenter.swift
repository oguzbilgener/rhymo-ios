//
//  RequestConfirmPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

let RequestConfirmAlertTag = 11
let RequestSuccessfulAlertTag = 99

class RequestConfirmPresenter: BasePresenter, UIAlertViewDelegate {
  
  var requestConfirmInteractor: RequestConfirmInteractor?
  var requestConfirmWireframe: RequestConfirmWireframe?
  var userInterface: RequestConfirmViewController?
  
  // MARK: events
  
  func onViewLoadFinish() {
    let venue = requestConfirmWireframe?.venue
    let track = requestConfirmWireframe?.track
    
    if(venue == nil || track == nil) {
      // We cannot operate without a proper venue or track, so better go back.
      backPressed(nil)
      return;
    }
    
    // TODO: do the in app purchase related things with interactor
    
    // show the parts in the user interface
    userInterface?.displayVenueDetails(venue!)
    userInterface?.displayChosenTrack(track!)
    userInterface?.displayPurchaseButton(value: 1.99, currency: "TL", verb: "Play")
  }

  func playConfirmButtonTouched(sender: UIButton) {
    // No purchase this time, go ahead and make the request right away
    showConfirmationDialog()
  }
  
  // MARK: - Payment
  
  func showConfirmationDialog() {
    let confirm = UIAlertView(title: "Confirm Your In-App Purchase", message: "Do you want to Play this song for 1.99 TL?", delegate: self, cancelButtonTitle: "No")
    confirm.addButtonWithTitle("Yes")
    confirm.tag = RequestConfirmAlertTag
    confirm.show()
  }
  
  // MARK: - Request
  
  func sendTrackRequest() {
    let venue = requestConfirmWireframe!.venue
    let track = requestConfirmWireframe!.track
    
    showActivityIndicator()
    requestConfirmInteractor?.sendTrackRequest(venue, track: track, result: { (error, success, reason) -> () in
      self.hideActivityIndicator()
      if(success) {
          // TODO: show a better alert
        let alert = UIAlertView(title: "Payment successful!", message: "Your track will be played shortly at \(venue.name). Thanks!", delegate: self, cancelButtonTitle: "Ok")
        alert.tag = RequestSuccessfulAlertTag
        alert.show()
      }
      else {
        if(error != nil) {
          debugPrintln(error)
          if(error?.code == RhymoBadRequestCode) {
            let alert = UIAlertView(title: "Slow down!", message: "You have sent too many requests already!", delegate: self, cancelButtonTitle: "Ok")
            println(reason)
            alert.tag = RequestSuccessfulAlertTag
            alert.show()
          }
          else {
            let alert = UIAlertView(title: "Oh no!", message: "Something went wrong...", delegate: self, cancelButtonTitle: "Ok")
            alert.tag = RequestSuccessfulAlertTag
            alert.show()
          }
          
        }
      }
    })
  }
  
  // MARK: - AlertView delegation
  
  func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
    if(alertView.tag == RequestSuccessfulAlertTag) {
      // close this VC when ok button is clicked
      backPressed(nil)
    }
  }
  
  func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if(alertView.tag == RequestConfirmAlertTag) {
      if(buttonIndex == 1) {
        sendTrackRequest()
      }
    }
  }
  
  // MARK: - Helpers
  
  func showActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
  }
  
  func hideActivityIndicator() {
    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
  }
  
  func backPressed(sender: AnyObject?) {
    userInterface?.navigationController?.popViewControllerAnimated(true)
  }
  
  func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }
}

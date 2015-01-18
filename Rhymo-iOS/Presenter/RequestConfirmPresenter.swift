//
//  RequestConfirmPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 18/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class RequestConfirmPresenter: BasePresenter {
  
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
    userInterface?.displayPurchaseButton(value: 0.99, currency: "TRY", verb: "Play")
  }

  func playConfirmButtonTouched(sender: UIButton) {
    debugPrintln("play confirmed, start purchase")
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

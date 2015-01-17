//
//  SearchTracksPresenter.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 14/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit

class SearchTracksPresenter: BasePresenter {
  
  
  var searchTracksInteractor: SearchTracksInteractor?
  var searchTracksWireframe: SearchTracksWireframe?
  var userInterface: SearchTracksViewController?
  
  
  // MARK: - UI Update Delegation
  
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

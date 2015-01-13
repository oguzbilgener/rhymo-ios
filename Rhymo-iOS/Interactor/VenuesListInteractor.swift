//
//  VenuesListInteractor.swift
//  Rhymo-iOS
//
//  Created by Oguz Bilgener on 13/01/15.
//  Copyright (c) 2015 Oguz Bilgener. All rights reserved.
//

import UIKit
import CoreLocation

let DesiredLocationAcurracyForVenues = kCLLocationAccuracyHundredMeters // 10 turned out to be too little
let ActivityTypeForVenues = CLActivityType.Fitness // receive activity even when not moving
let LocationMaximumAttempts = 10
let LocationMaximumFailedAttempts = 3
let LocationTimeoutInSeconds = 90
let LocationInvalidationPeriod = 5 * 60 // 5 minutes

class VenuesListInteractor: BaseInteractor, CLLocationManagerDelegate {
  
  var output:  VenuesListPresenter?
  
  let locationManager = CLLocationManager() // aware: strong reference
  
  enum FailReason: Int {
    case None = 0
    case NoPermission
    case Timeout
    case Inaccurate
    case OtherError
  }
  
  private var tryingToGetLocation = false
  private var startTimeForTrying = NSDate()
  private var currentAttempts = 0
  private var failedAttempts = 0
  private var locationTimer: NSTimer?
  
  var locationResultClosure: ((success: Bool, failReason: FailReason?, location: CLLocation?) -> ())?
  var locationLastUpdated: NSDate?
  var lastLocation: CLLocation?
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  // MARK - Location Interface
  
  func getDeviceLocation(resultClosure: ((success: Bool, failReason: FailReason?, location: CLLocation?) -> ())!) {
    self.locationResultClosure = resultClosure
    if(!canUseLocation()) {
      // TODO: Restrict app usage because we need location
      submitFailedLocationResult(.NoPermission)
      return
    }
    self.tryingToGetLocation = true
    self.startTimeForTrying = NSDate()
    
    self.locationManager.desiredAccuracy = DesiredLocationAcurracyForVenues
    self.locationManager.activityType = ActivityTypeForVenues
    self.currentAttempts = 0
    self.failedAttempts = 0
    self.locationManager.startUpdatingLocation()
    
    if(locationTimer != nil) {
      self.locationTimer!.invalidate()
    }
    self.locationTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(LocationTimeoutInSeconds), target: self, selector: "timeoutHappened:", userInfo: nil, repeats: false)
  }
  
  private func stopTryingToGetLocation() {
    self.locationManager.stopUpdatingLocation()
    if(locationTimer != nil) {
      self.locationTimer!.invalidate()
    }
    self.tryingToGetLocation = false
  }
  
  private func submitFailedLocationResult(reason: FailReason) {
    if let result = locationResultClosure {
      result(success: false, failReason: reason, location: nil)
      self.locationResultClosure = nil
    }
  }
  
  private func submitSuccessfulLocationResult(location: CLLocation) {
    if let result = locationResultClosure {
      result(success: true, failReason: nil, location: location)
      self.locationResultClosure = nil
    }
  }
  
  func isTryingToGetLocation() -> Bool {
    return tryingToGetLocation
  }
  
  func canUseLocation() -> Bool {
    let enabled = CLLocationManager.locationServicesEnabled()
    if(!enabled) {
      return true
    }
    let status = CLLocationManager.authorizationStatus()
    switch(status) {
    case .Authorized, .AuthorizedWhenInUse:
      return true
    case .NotDetermined:
      self.locationManager.requestWhenInUseAuthorization()
      return true
    case .Restricted:
      return false
    case .Denied:
      return false
    }
  }
  
  func lastLocationValid() -> Bool {
    if(self.lastLocation != nil && locationLastUpdated != nil) {
      if(Int(NSDate().timeIntervalSince1970) - Int(locationLastUpdated!.timeIntervalSince1970) < LocationInvalidationPeriod) {
        return true
      }
    }
    return false
  }
  
  // MARK: - Location Events
  func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
    self.failedAttempts = self.failedAttempts + 1
    if(self.failedAttempts > LocationMaximumFailedAttempts) {
      self.stopTryingToGetLocation()
      self.submitFailedLocationResult(.OtherError)
    }
    // TODO: send this other error to us
  }
  
  func timeoutHappened(sender: AnyObject?) {
    self.stopTryingToGetLocation()
    self.submitFailedLocationResult(.Timeout)
  }
  
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let location = locations.last as CLLocation
    let accurracy = location.horizontalAccuracy
    let time = location.timestamp
    let coords = location.coordinate
    
    currentAttempts = currentAttempts + 1
    
    if(accurracy < 0 || accurracy > DesiredLocationAcurracyForVenues) {
      // not accurrate yet
      if(currentAttempts >= LocationMaximumAttempts) {
        self.stopTryingToGetLocation()
        self.submitFailedLocationResult(.Inaccurate)
      }
      // else wait
    }
    else {
      self.locationLastUpdated = NSDate()
      self.stopTryingToGetLocation()
      self.submitSuccessfulLocationResult(location)
    }
  }
  
  // MARK: - HTTP Interactions
  func getVenuesNearby(location: CLLocation, result: (error: NSError?, venues: [Venue]!)->()) {
    let client = RhymoClient()
    client.getVenuesNearby(Point(location: location), result: result)
  }
}

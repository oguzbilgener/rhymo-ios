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
let BeaconMaximumAttempts = 2
let BeaconTimeoutInSeconds = 20

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
  private let beaconScanner = UBUriBeaconScanner()
  private var beaconScanCount = 0
  private var beaconTimer: NSTimer?
  
  var locationResultClosure: ((success: Bool, failReason: FailReason?, location: CLLocation?) -> ())?
  var locationLastUpdated: NSDate?
  var lastLocation: CLLocation?
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  // MARK: - Location Interface
  
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
      self.lastLocation = location
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
    case .AuthorizedWhenInUse:
      return true
    case .NotDetermined:
      self.locationManager.requestWhenInUseAuthorization()
      return true
    case .Restricted:
      return false
    case .Denied:
      return false
    default:
      return false
    }
  }
  
  func lastLocationValid() -> Bool {
    if(RhymoClient.fakeLocationEnabled()) {
      self.lastLocation = CLLocation(latitude: 39.9235423, longitude: 32.8213822)
      return true
    }
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
    let location = locations.last as! CLLocation
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
  
  // MARK: - Beacon interactions
  
  func scanBeacons(result: ([Venue])->()) {
    if(beaconScanCount != 0) {
      return
    }
    beaconScanner.startScanningWithUpdateBlock {
      self.beaconScanCount = self.beaconScanCount + 1
      if(self.beaconScanCount >= BeaconMaximumAttempts) {
        self.beaconScanCount = 0
        self.beaconScanner.stopScanning()
        var venues = [Venue]()
        if(self.beaconScanner.beacons() != nil) {
          if(self.beaconTimer != nil) {
            self.beaconTimer!.invalidate()
          }
          let beacons = self.beaconScanner.beacons() as! [UBUriBeacon]
          
          var nearbyVenueIds = [Int]()
          // find all the relevant nearby venue ids
          for beacon in beacons {
            if(beacon.URI.scheme == "rhymo") {
              if let paths = beacon.URI.pathComponents as? [String] {
                if(count(paths) >= 2 && beacon.URI.host == "near") {
                  if let venueId = paths[1].toInt() {
                    nearbyVenueIds.append(venueId)
                  }
                }
              }
            }
          }
          // then filter from all the venues that are really nearby
          if let allVenues = self.output?.venues {
            venues = allVenues.filter { contains(nearbyVenueIds, $0.id) }
          }
        }
        result(venues)
      }
    }
    if(beaconTimer != nil) {
      beaconTimer!.invalidate()
    }
    beaconTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(BeaconTimeoutInSeconds), target: self, selector: "scanTimeoutHappened:", userInfo: nil, repeats: false)
  }
  
  func scanTimeoutHappened(sender: AnyObject?) {
    self.beaconScanCount = 0
    self.beaconScanner.stopScanning()
  }
  
  // MARK: - HTTP Interactions
  
  func getVenuesNearby(location: CLLocation, result: (error: NSError?, venues: [Venue]!)->()) {
    let client = RhymoClient()
    client.getVenuesNearby(Point(location: location), result: result)
  }
  
  // MARK: - Search
  
  func filterVenuesByName(#venues: [Venue], keyword: String) -> [Venue] {
    if(count(keyword) == 0) {
      return venues
    }
    let keywordLowercase = keyword.lowercaseString
    var filteredVenues = [Venue]()
    for venue in venues {
      if(venue.name.lowercaseString.rangeOfString(keywordLowercase) != nil) {
        filteredVenues.append(venue)
      }
    }
    return filteredVenues
  }
}

//
//  LocationManager.swift
//  locations
//
//  Created by Joefrey Kibuule on 3/5/15.
//  Copyright (c) 2015 Joefrey Kibuule. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager : NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    class var sharedInstance: LocationManager {
        struct Static {
            static let instance = LocationManager()
        }
        
        return Static.instance
    }
    
    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = LocationSettings.sharedInstance.locationAccuracy.desiredAccuracy
        locationManager.requestAlwaysAuthorization()
    }
    
    func changeAccuracy(accuracy: CLLocationAccuracy) {
        locationManager.desiredAccuracy = accuracy
        LocationSettings.sharedInstance.locationAccuracy = LocationSettings.LocationAccuracy(accuracy: accuracy)
    }
    
    func startMonitoring () {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func stopMonitoring() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let numberOfSavedLocationsForAccuracy = LocationSettings.sharedInstance.increaseNumberOfSavedLocationForAccuracy(locations.count, accuracy: LocationSettings.sharedInstance.locationAccuracy)
        let alert = "Accuracy: \(LocationSettings.sharedInstance.locationAccuracy): New locations: \(locations.count), Total locations: \(numberOfSavedLocationsForAccuracy)"
        println(alert)
            
        if LocationSettings.sharedInstance.notificationsEnabled {
            
            let notification = UILocalNotification()
            notification.alertBody = alert
            notification.fireDate = NSDate()
            notification.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("LocationUpdated", object: nil)
    }
    
}

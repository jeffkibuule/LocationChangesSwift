//
//  LocationSettings.swift
//  locations
//
//  Created by Joefrey Kibuule on 3/5/15.
//  Copyright (c) 2015 Joefrey Kibuule. All rights reserved.
//

import UIKit
import CoreLocation

class LocationSettings {
    class var sharedInstance: LocationSettings {
        struct Static {
            static let instance = LocationSettings()
        }
        
        return Static.instance
    }
    
    struct Constants {
        static let LocationAccuracyKey = "accuracy"
        static let NotificationsEnabledKey = "notifications"
    }
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    enum LocationAccuracy : Int, Printable {
        case BestForNavigation = 0
        case Best
        case NearestTenMeters
        case HundredMeters
        case Kilometer
        case ThreeKilometers
        
        var description : String {
            switch self {
            case BestForNavigation:
                return "BestForNavigation"
            case Best:
                return "Best"
            case NearestTenMeters:
                return "NearestTenMeters"
            case HundredMeters:
                return "HundredMeters"
            case Kilometer:
                return "Kilometer"
            case ThreeKilometers:
                return "ThreeKilometers"
            }
        }
        
        var desiredAccuracy : CLLocationAccuracy {
            switch self {
            case BestForNavigation:
                return kCLLocationAccuracyBestForNavigation
            case Best:
                return kCLLocationAccuracyBest
            case NearestTenMeters:
                return kCLLocationAccuracyNearestTenMeters
            case HundredMeters:
                return kCLLocationAccuracyHundredMeters
            case Kilometer:
                return kCLLocationAccuracyKilometer
            case ThreeKilometers:
                return kCLLocationAccuracyThreeKilometers
            }
        }
        
        init(accuracy: CLLocationAccuracy) {
            switch (accuracy) {
            case kCLLocationAccuracyBestForNavigation:
                self = .BestForNavigation
            case kCLLocationAccuracyBest:
                self = .Best
            case kCLLocationAccuracyNearestTenMeters:
                self = .NearestTenMeters
            case kCLLocationAccuracyHundredMeters:
                self = .HundredMeters
            case kCLLocationAccuracyKilometer:
                self = .Kilometer
            case kCLLocationAccuracyThreeKilometers:
                self = .ThreeKilometers
            default:
                self = .HundredMeters
            }
        }
    }
    
    var locationAccuracy: LocationAccuracy {
        get {
            if let accuracy = defaults.objectForKey(Constants.LocationAccuracyKey) as? Int {
                return LocationAccuracy(rawValue: accuracy)!
            }
            
            return .HundredMeters
        }
        set {
            defaults.setInteger(newValue.rawValue, forKey: Constants.LocationAccuracyKey)
            defaults.synchronize()
        }
    }
    
    var notificationsEnabled: Bool {
        get {
            if let notifications = defaults.objectForKey(Constants.NotificationsEnabledKey) as? Bool {
                return notifications
            }
            
            return true
        }
        set {
            defaults.setBool(newValue, forKey: Constants.NotificationsEnabledKey)
            defaults.synchronize()
        }
    }
    
    func getNumberOfSavedLocationsForAccuracy(accuracy: LocationAccuracy) -> Int {
        if let numberOfSavedLocations = defaults.objectForKey(accuracy.description) as? Int {
            return numberOfSavedLocations
        }
        
        return 0
    }
    
    func setNumberOfSavedLocationForAccuracy(numberOfSavedLocations: Int, accuracy: LocationAccuracy) {
        defaults.setInteger(numberOfSavedLocations, forKey: accuracy.description)
        defaults.synchronize()
    }
    
    func increaseNumberOfSavedLocationForAccuracy(amount: Int, accuracy: LocationAccuracy) -> Int {
        var numberOfSavedLocationsForAccuracy = self.getNumberOfSavedLocationsForAccuracy(accuracy)
        
        numberOfSavedLocationsForAccuracy += amount
        self.setNumberOfSavedLocationForAccuracy(numberOfSavedLocationsForAccuracy, accuracy: accuracy)
        
        return numberOfSavedLocationsForAccuracy
    }
}

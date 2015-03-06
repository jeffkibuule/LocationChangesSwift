//
//  ViewController.swift
//  locations
//
//  Created by Joefrey Kibuule on 3/5/15.
//  Copyright (c) 2015 Joefrey Kibuule. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var accuracySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var bestLabel: UILabel!
    @IBOutlet weak var nearestTenLabel: UILabel!
    @IBOutlet weak var hundredLabel: UILabel!
    @IBOutlet weak var kilometerLabel: UILabel!
    @IBOutlet weak var threeKilometersLabel: UILabel!
    
    
    @IBOutlet weak var notificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accuracySegmentedControl.selectedSegmentIndex = LocationSettings.sharedInstance.locationAccuracy.rawValue
        notificationsSwitch.on = LocationSettings.sharedInstance.notificationsEnabled
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateUI"), name: "LocationUpdated", object: nil)
        
        updateUI()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: Actions
    
    @IBAction func accuracyChanged(sender: UISegmentedControl) {
        var locationAccuracy: LocationSettings.LocationAccuracy = .HundredMeters
        switch (accuracySegmentedControl.selectedSegmentIndex) {
        case 0:
            locationAccuracy = .BestForNavigation
        case 1:
            locationAccuracy = .Best
        case 2:
            locationAccuracy = .NearestTenMeters
        case 3:
            locationAccuracy = .HundredMeters
        case 4:
            locationAccuracy = .Kilometer
        case 5:
            locationAccuracy = .ThreeKilometers
        default:
            locationAccuracy = .HundredMeters
        }
        
        LocationManager.sharedInstance.changeAccuracy(locationAccuracy.desiredAccuracy)
    }
    
    @IBAction func notificationsToggled(sender: UISwitch) {
        LocationSettings.sharedInstance.notificationsEnabled = sender.on
    }
    
    func updateUI() {
        navLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.BestForNavigation))"
        bestLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.Best))"
        nearestTenLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.NearestTenMeters))"
        hundredLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.HundredMeters))"
        kilometerLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.Kilometer))"
        threeKilometersLabel.text = "\(LocationSettings.sharedInstance.getNumberOfSavedLocationsForAccuracy(LocationSettings.LocationAccuracy.ThreeKilometers))"
    }
}


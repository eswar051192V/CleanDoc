//
//  CDLocationService.swift
//  CleanDoc
//
//  Created by Eswar Venigalla on 18/01/19.
//  Copyright © 2019 HiTech. All rights reserved.
//

import Foundation
import CoreLocation
protocol CDLocationServiceDelegate: class {
    func locationRecieved()
}

protocol CDLocationServiceProtocol {
    init(delegate: CDLocationServiceDelegate!)
    func initialiseLocation()
    func getCurrentLocation() -> CLLocation!
}

class CDLocationService: NSObject, CDLocationServiceProtocol {
    private weak var delegate: CDLocationServiceDelegate!
    
    private var currentLocation: CLLocation!
    
    private lazy var coreLocationManager: CLLocationManager! = {
        let locationMan = CLLocationManager()
        locationMan.delegate = self
        locationMan.distanceFilter = 10
        locationMan.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return locationMan
    }()
    
    required init(delegate: CDLocationServiceDelegate!) {
        super.init()
        self.delegate = delegate
    }
    
    func set(delegate: CDLocationServiceDelegate!) {
        self.delegate = delegate
        self.coreLocationManager.allowsBackgroundLocationUpdates = true
        self.coreLocationManager.startUpdatingLocation()
    }
    
    func initialiseLocation() {
        self.coreLocationManager.requestLocation()
    }
    
    func getCurrentLocation() -> CLLocation! {
        return self.currentLocation
    }
    
}

extension CDLocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

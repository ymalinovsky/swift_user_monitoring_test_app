//
//  Geofencing.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 28.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Geofencing {
    private func getCircularRegion(withGeotification geotification: Geotification) -> CLCircularRegion {
        let center = CLLocationCoordinate2D(latitude: geotification.latitude, longitude: geotification.longitude)
        
        let clampedRadius = min(geotification.radius, appDelegate.locationManager.maximumRegionMonitoringDistance)
        let region = CLCircularRegion(center: center, radius: clampedRadius, identifier: geotification.identifier)

        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        
        return region
    }
    
    func startMonitoring(controller: UIViewController, geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(controller: controller, withTitle:"Error", message: "Geofencing is not supported on this device!")
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(controller: controller, withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
        }
        let region = self.getCircularRegion(withGeotification: geotification)
        appDelegate.locationManager.startMonitoring(for: region)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in appDelegate.locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
            appDelegate.locationManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func handleGeofencingEvent(forRegion region: CLRegion, isEnterToRegion: Bool) {
        let timestamp = Int(Date().timeIntervalSinceReferenceDate)
        
        if UserDefaults.standard.value(forKey: "geofencingTimestamp") != nil {
            let geofencingTimestamp = UserDefaults.standard.integer(forKey: "geofencingTimestamp")
            
            if timestamp - geofencingTimestamp > 1 { // Geofence Bug in iOS: prevent duplicate calls for region monitoring.
                UserDefaults.standard.set(timestamp, forKey: "geofencingTimestamp")
                
                if isEnterToRegion {
                    self.didEnterRegion(forRegion: region)
                } else {
                    self.didExitRegion(forRegion: region)
                }
            }
        } else {
            UserDefaults.standard.set(timestamp, forKey: "geofencingTimestamp")

            if isEnterToRegion {
                self.didEnterRegion(forRegion: region)
            } else {
                self.didExitRegion(forRegion: region)
            }
        }
    }
    
    private func didEnterRegion(forRegion region: CLRegion) {
        print("didEnterRegion")
        firebaseDatabase.addGeofenceNotificationAboutObservingUser(userID: currentUser, identifier: region.identifier)
    }
    
    private func didExitRegion(forRegion region: CLRegion) {
        print("didExitRegion")
        firebaseDatabase.addGeofenceNotificationAboutObservingUser(userID: currentUser, identifier: region.identifier)
    }
}

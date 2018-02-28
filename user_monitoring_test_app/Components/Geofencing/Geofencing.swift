//
//  Geofencing.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 27.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import GoogleMaps

class Geofencing {
//    func region(withGeotification geotification: Geotification) -> CLCircularRegion {
//        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
//
//        region.notifyOnEntry = (geotification.eventType == .onEntry)
//        region.notifyOnExit = !region.notifyOnEntry
//        return region
//    }
//
//    func startMonitoring(geotification: Geotification) {
//
//        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            showAlert(withTitle:"Error", message: "Geofencing is not supported on this device!")
//            return
//        }
//
//        if CLLocationManager.authorizationStatus() != .authorizedAlways {
//            showAlert(withTitle:"Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.")
//        }
//
//        let region = self.region(withGeotification: geotification)
//
//        locationManager.startMonitoring(for: region)
//    }
//
//    func stopMonitoring(geotification: Geotification) {
//        for region in locationManager.monitoredRegions {
//            guard let circularRegion = region as? CLCircularRegion, circularRegion.identifier == geotification.identifier else { continue }
//            locationManager.stopMonitoring(for: circularRegion)
//        }
//    }
}

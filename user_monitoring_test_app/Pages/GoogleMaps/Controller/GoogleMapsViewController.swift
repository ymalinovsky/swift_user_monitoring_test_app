//
//  GoogleMapsViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class GoogleMapsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var zoomLevel: Float = 6.0
    
    var observedUser: MonitoringUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        
        putMarkerToGoogleMap()
    }
    
    func putMarkerToGoogleMap() {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 50.25, longitude: 28.75)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "dot")
        marker.map = mapView
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: zoomLevel)
        
        mapView.animate(to: camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            print("Location status is OK always.")
        case .authorizedWhenInUse:
            print("Location status is OK when app in use.")
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopMonitoringSignificantLocationChanges()
        print("Error: \(error)")
    }
}



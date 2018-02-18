//
//  GoogleMapsViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    var zoomLevel: Float = 6.0
    
    var observedUser: MonitoringUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.settings.compassButton = true
        
        putMarkerToGoogleMap(latitude: 50.25, longitude: 28.75)
    }
    
    func putMarkerToGoogleMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.icon = UIImage(named: "dot")
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
}



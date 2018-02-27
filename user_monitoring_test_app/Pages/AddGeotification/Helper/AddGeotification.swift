//
//  AddGeotification.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 26.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class AddGeotification {
    
    var controller: AddGeotificationViewController
    
    init(controller: AddGeotificationViewController) {
        self.controller = controller
    }
    
    func updateGoogleMapMarker() {
        if let userIndex = fullUsersList.index(where: { $0.userID == controller.observedUser.userID}) {
            if let latitude = fullUsersList[userIndex].latitude, let longitude = fullUsersList[userIndex].longitude {
                controller.observedUserMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                controller.observedUserMarker.map = controller.mapView
                
                let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: controller.zoomLevel)
                controller.mapView.animate(to: camera)
            }
        }
    }
}

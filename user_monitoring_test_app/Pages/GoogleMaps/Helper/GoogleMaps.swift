//
//  GoogleMaps.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 22.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class GoogleMaps {
    
    var controller: GoogleMapsViewController!
    
    init(controller: GoogleMapsViewController) {
        self.controller = controller
    }
    
    func getMarkerProfileImage(profileImage: UIImage) -> UIImage {
        let sizeMultiplier: CGFloat = 0.1
        let resizedProfileImage = resizeImage(image: profileImage, toSize: CGSize(width: profileImage.size.width * sizeMultiplier , height: profileImage.size.height * sizeMultiplier))
        let profileImageView = UIImageView(image: resizedProfileImage)
        
        profileImageView.frame.size.width = profileImageView.frame.size.height
        
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.clear.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.clipsToBounds = true
        
        return UIImage(view: profileImageView)
    }
    
    func updateGoogleMapMarker() {
        if let userIndex = fullUsersList.index(where: { $0.userID == controller.observedUser.userID}) {
            if let latitude = fullUsersList[userIndex].latitude, let longitude = fullUsersList[userIndex].longitude {
                self.putMarkerToGoogleMap(latitude: latitude, longitude: longitude)
            }
        }
    }
    
    func putMarkerToGoogleMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        controller.marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        controller.marker.map = controller.mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: controller.zoomLevel)
        controller.mapView.animate(to: camera)
    }
}

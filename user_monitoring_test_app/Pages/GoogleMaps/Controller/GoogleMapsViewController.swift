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
    
    var zoomLevel: Float = 15.0
    
    var observedUser: MonitoringUser!
    
    let marker = GMSMarker()
    
    var helper: GoogleMaps!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.settings.compassButton = true
        
        updateGoogleMapMarker()
        
        firebaseStorage.downloadProfileImage(userID: observedUser.userID)
        
        helper = GoogleMaps(controller: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(googleMapsVCMarkerMustBeReload), name: .googleMapsVCMarkerMustBeReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileImageDownloadCompletedSuccessfully), name: .profileImageDownloadCompletedSuccessfully, object: nil)
    }
    
    @objc func googleMapsVCMarkerMustBeReload(notification: NSNotification) {
        updateGoogleMapMarker()
    }
    
    @objc func profileImageDownloadCompletedSuccessfully(notification: NSNotification) {
        if let notificationData = notification.userInfo?.first?.value {
            let data = notificationData as! [String: NSDictionary]
            
            if let profileImageFilePath = data[observedUser.userID]?["profileImageFilePath"] {
                if let profileImage = UIImage(contentsOfFile: profileImageFilePath as! String) {
                    marker.icon = helper.getMarkerProfileImage(profileImage: profileImage)
                }
            }
        }
    }
    
    func updateGoogleMapMarker() {
        if let userIndex = fullUsersList.index(where: { $0.userID == observedUser.userID}) {
            if let latitude = fullUsersList[userIndex].latitude, let longitude = fullUsersList[userIndex].longitude {
                putMarkerToGoogleMap(latitude: latitude, longitude: longitude)
            }
        }
    }
    
    func putMarkerToGoogleMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.icon = UIImage(named: "dot")
        marker.map = mapView
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoomLevel)
        mapView.animate(to: camera)
    }
    
}



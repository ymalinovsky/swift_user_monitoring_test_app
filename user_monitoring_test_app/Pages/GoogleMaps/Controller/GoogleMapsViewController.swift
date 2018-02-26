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
        
        helper = GoogleMaps(controller: self)
        
        mapView.settings.compassButton = true
        
        helper.updateGoogleMapMarker()
        marker.icon = UIImage(named: "dot")
        
        firebaseStorage.downloadProfileImage(userID: observedUser.userID)
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: helper, action: #selector(helper.addGeofencingGroundOverlay))
        
        NotificationCenter.default.addObserver(self, selector: #selector(googleMapsVCMarkerMustBeReload), name: .googleMapsVCMarkerMustBeReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(profileImageDownloadCompletedSuccessfully), name: .profileImageDownloadCompletedSuccessfully, object: nil)
    }
    
    @objc func googleMapsVCMarkerMustBeReload(notification: NSNotification) {
        helper.updateGoogleMapMarker()
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
}



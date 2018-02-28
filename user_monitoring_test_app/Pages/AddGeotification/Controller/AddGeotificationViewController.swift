//
//  AddGeotificationViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 26.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit
import GoogleMaps

class AddGeotificationViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var eventTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var radiusTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    
    var observedUser: MonitoringUser!
    var zoomLevel: Float!
    
    let marker = GMSMarker()
    var observedUserMarker: GMSMarker!
    
    var helper: AddGeotification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helper = AddGeotification(controller: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        helper.updateGoogleMapMarker()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addGeotification))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.post(name: .googleMapsVCMarkerMustBeReload, object: nil, userInfo: nil)
    }

    @objc func addGeotification() {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        
        let radius = Double(radiusTextField.text!) ?? 100
        let identifier = NSUUID().uuidString
        let note = noteTextField.text ?? ""
        let eventType: EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
        
        firebaseDatabase.addGeotificationToObservingUser(userID: currentUser, observedUserID: observedUser.userID, latitude: latitude, longitude: longitude, radius: radius, identifier: identifier, note: note, eventType: eventType)
        
        navigationController?.popViewController(animated: true)
    }
}

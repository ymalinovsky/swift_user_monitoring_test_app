//
//  UserObservedListViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit
import CoreLocation

class UserObservedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var locationManager = CLLocationManager()
    
    let userObservedListCellIdentifier = "userObservedListCell"
    let userObservedListSegueIdentifier = "userObservedListSegue"
    
    var selectedUser: MonitoringUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = currentUser
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userObservedListVCTableViewMustBeReload), name: .userObservedListVCTableViewMustBeReload, object: nil)
    }
    
    @objc func userObservedListVCTableViewMustBeReload(notification: NSNotification) {
        tableView.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case userObservedListSegueIdentifier:
                let googleMapsVC = segue.destination as! GoogleMapsViewController
                googleMapsVC.observedUser = selectedUser
            default:
                print("Unpredicted segue identifier.")
            }
        }
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observedUsersListByCurrentUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userObservedListCellIdentifier)!
        
        cell.textLabel?.text = observedUsersListByCurrentUser[indexPath.row].userID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = observedUsersListByCurrentUser[indexPath.row]
        
        performSegue(withIdentifier: userObservedListSegueIdentifier, sender: self)
    }
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            firebaseDatabase.saveUserLocations(userID: currentUser, location: location)
        }
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
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

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
    var assignUserObserveToUserQueue = [AssignUserObserveToUserQueue]()
    
    let assignUserObserveToUserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "assignUserObserveToUserViewController") as! AssignUserObserveToUserViewController
    
    let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "menuViewController") as! MenuViewController
    
    var shouldExpandMenu = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = currentUser
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        hamburgerMenu.addLeftSidePanel(centerVC: self, leftVC: menuVC)
        
        NotificationCenter.default.addObserver(self, selector: #selector(agreeUserObservingOrNot), name: .agreeUserObservingOrNot, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userObservedListVCTableViewMustBeReload), name: .userObservedListVCTableViewMustBeReload, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userObservedListVCRemoveItemFromAssignUserObserveToUserQueue), name: .userObservedListVCRemoveItemFromAssignUserObserveToUserQueue, object: nil)
    }
    
    @objc func agreeUserObservingOrNot(notification: NSNotification) {
        if let notificationData = notification.userInfo?.first?.value {
            let observedUserData = notificationData as! [String: String]
            
            if let observedUserID = observedUserData["observedUserID"] {
                assignUserObserveToUserQueue.append(AssignUserObserveToUserQueue(observedUserID: observedUserID))
                
                if let topVC = UIApplication.topViewController() {
                    let topVCName = NSStringFromClass(topVC.classForCoder).components(separatedBy: ".").last!
                    if topVCName == "UserObservedListViewController" {
                        assignUserObserveToUserVC.observedUserID = observedUserID
                        
                        present(assignUserObserveToUserVC, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func userObservedListVCTableViewMustBeReload(notification: NSNotification) {
        tableView.reloadData()
    }
    
    @objc func userObservedListVCRemoveItemFromAssignUserObserveToUserQueue(notification: NSNotification) {
        if let notificationData = notification.userInfo?.first?.value {
            let observedUserData = notificationData as! [String: String]
            
            if let observedUserID = observedUserData["observedUserID"] {
                assignUserObserveToUserQueue = assignUserObserveToUserQueue.filter() { $0.observedUserID != observedUserID }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if assignUserObserveToUserQueue.count > 0 {
            if let userObserveInQueue = assignUserObserveToUserQueue.last {
                let observedUserID = userObserveInQueue.observedUserID
                assignUserObserveToUserVC.observedUserID = observedUserID
                
                present(assignUserObserveToUserVC, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        shouldExpandMenu = true
    }
    
    // MARK: Actions
    
    @IBAction func menuAction(_ sender: UIBarButtonItem) {
        hamburgerMenu.animateLeftPanel(centerVC: self, shouldExpand: shouldExpandMenu)
        
        if shouldExpandMenu {
            shouldExpandMenu = false
        } else {
            shouldExpandMenu = true
        }
    }
    
    // MARK: Navigation

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

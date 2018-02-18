//
//  UserObservedListViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class UserObservedListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let userObservedListCellIdentifier = "userObservedListCell"
    let userObservedListSegueIdentifier = "userObservedListSegue"
    
    var selectedUser: MonitoringUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.title = currentUser
        
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
}

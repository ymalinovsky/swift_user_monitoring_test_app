//
//  AddUserToObserveViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class AddUserToObserveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var usersListToObserve: [MonitoringUser]!
    
    let usersListToObserveCellIdentifier = "usersListToObserveCell"
    
    let helper = AddUserToObserve()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        usersListToObserve = helper.getUsersObserveList()
    }

    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersListToObserve.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: usersListToObserveCellIdentifier)!
        
        cell.textLabel?.text = usersListToObserve[indexPath.row].userID
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = usersListToObserve[indexPath.row]
        
        firebaseDatabase.addObservedUser(userID: currentUser, observedUserID: user.userID)
        
        navigationController?.popViewController(animated: true)
    }
}

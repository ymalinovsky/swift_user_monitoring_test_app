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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        
    }
}

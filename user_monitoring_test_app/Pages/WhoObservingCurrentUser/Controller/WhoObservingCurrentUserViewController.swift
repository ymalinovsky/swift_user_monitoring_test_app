//
//  WhoObservingCurrentUserViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 19.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class WhoObservingCurrentUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let whoObservingCurrentUserCellIdentifier = "whoObservingCurrentUserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersListWhoObservingCurrentUser.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: whoObservingCurrentUserCellIdentifier)!
        
        cell.textLabel?.text = usersListWhoObservingCurrentUser[indexPath.row].userID
        
        return cell
    }
    
}

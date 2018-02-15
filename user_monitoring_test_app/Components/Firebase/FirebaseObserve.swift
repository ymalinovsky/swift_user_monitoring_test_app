//
//  FirebaseObserve.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseObserve {
    func newUserObserver() {
        let chatDB = Database.database().reference().child("users")
        chatDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            fullUsersList.append(MonitoringUser(userID: String(describing: userData["id"])))
        })
    }
    
}

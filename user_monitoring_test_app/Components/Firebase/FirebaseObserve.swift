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
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            let userID = userData["id"] as! String
            
            fullUsersList.append(MonitoringUser(userID: userID))
            
            self.observedUserObserver(userID: userID)
        })
    }
    
    func observedUserObserver(userID: String) {
        let observedUsersDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("observedUsers")
        
        observedUsersDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            userData.forEach({ (observedUser ) in
                let userID = observedUser.value
                
                observedUsersListByCurrentUser.append(MonitoringUser(userID: userID as! String))
                
                NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
            })
        })
    }
}

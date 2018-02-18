//
//  FirebaseObserve.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseObserve {
    func newUserObserver() {
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            let userID = userData["id"] as! String
            
            if !fullUsersList.contains(where: { $0.userID == userID }) {
                fullUsersList.append(MonitoringUser(userID: userID))
                self.observedUserObserver(userID: userID)
                self.userCoordinatesObserver(userID: userID)
            }
        })
    }
    
    func observedUserObserver(userID: String) {
        let observedUsersDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("observedUsers")
        
        observedUsersDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
             let userID = userData["id"] as! String
            
            observedUsersListByCurrentUser.append(MonitoringUser(userID: userID))
            NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
        })
    }
    
    func userCoordinatesObserver(userID: String) {
        let coordinatesDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("coordinates")
        
        coordinatesDB.observe(.childChanged, with: { (snapshot) -> Void in
            switch snapshot.key {
            case "latitude":
                for user in fullUsersList {
                    if user.userID == userID {
//                        user.latitude = CLLocationDegrees(String(describing: snapshot.value!))
                    }
                }
            case "longitude":
                fullUsersList.forEach({ (user) in
                    if user.userID == userID {
//                        user.longitude = CLLocationDegrees(String(describing: snapshot.value!))
                    }
                })
            default: break
            }
            
            print("ATATA!!!")
//            NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
        })
    }
}

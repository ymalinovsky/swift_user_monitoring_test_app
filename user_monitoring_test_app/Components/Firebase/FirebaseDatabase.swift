//
//  FirebaseDatabase.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseDatabase {
    func addNewUser(userID: String) {
        let userDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func addCheckNewUsersObserve(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(observedUserID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("checkNewUsersObserve").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func removeNewUsersObserve(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("checkNewUsersObserve").child(observedUserID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).removeValue()
    }
    
    func addObservedUser(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(observedUserID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("observedUsers").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func saveUserLocations(userID: String, location: CLLocation) {
        let userDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        let coordinates = ["latitude" : location.coordinate.latitude, "longitude" : location.coordinate.longitude]
        
        userDB.child("coordinates").setValue(coordinates) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func getUsersListByUserObserving(userID: String) {
        let userDB = Database.database().reference().child("users")

        userDB.observeSingleEvent(of: .value) { (snapshot) in
            let usersData = snapshot.value as! NSDictionary
            
            for userData in usersData {
                let user = userData.value as! NSDictionary
                let userID = user["id"] as! String
                
                if userID == currentUser, user["observedUsers"] != nil {
                    let observedUsers = user["observedUsers"] as! NSDictionary
                    
                    for observedUser in observedUsers {
                        let observedUser = observedUser.value as! NSDictionary
                        let observedUserID = observedUser["id"] as! String
                        
                        usersListByCurrentUserObserving.append(MonitoringUser(userID: observedUserID, latitude: nil, longitude: nil))
                    }
                }
            }
            
            NotificationCenter.default.post(name: .whoObservingCurrentUserVCTableViewMustBeReload, object: nil, userInfo: nil)
        }
    }
}

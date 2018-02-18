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
    
    func addObservedUser(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("observedUsers").child(observedUserID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("id").setValue(observedUserID) { (error, ref) in
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
}

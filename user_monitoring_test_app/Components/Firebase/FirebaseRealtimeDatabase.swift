//
//  FirebaseRealtimeDatabase.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseRealtimeDatabase {
    func addNewUser(userID: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID))
        
        userDB.child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func addCheckNewUsersObserve(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: observedUserID))
        
        userDB.child("checkNewUsersObserve").child(getValidUserID(userID: userID)).child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func removeNewUsersObserve(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID))
        
        userDB.child("checkNewUsersObserve").child(getValidUserID(userID: observedUserID)).removeValue()
    }
    
    func addObservedUser(userID: String, observedUserID: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: observedUserID))
        
        userDB.child("observedUsers").child(getValidUserID(userID: userID)).child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func saveUserLocations(userID: String, location: CLLocation) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID))
        
        let coordinates = ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
        
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
    
    func addGeotificationToObservingUser(userID: String, observedUserID: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, identifier: String, note: String, eventType: EventType) {
        let geotification = ["latitude": String(describing: latitude), "longitude": String(describing: longitude), "radius": String(describing: radius), "note": note , "eventType": String(describing: eventType)]
        
        // Current User -> Observed Users -> Observed User -> Geotifications
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("observedUsers").child(getValidUserID(userID: observedUserID)).child("geotifications")
        userDB.child(identifier).setValue(geotification) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
        
        // Observed User -> Geotifications
        let observedUser = Database.database().reference().child("users").child(getValidUserID(userID: observedUserID)).child("geotifications")
        observedUser.child(identifier).setValue(geotification) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func initGeofencingEvents() {
        let userDB = Database.database().reference().child("users")
        
        userDB.observeSingleEvent(of: .value) { (snapshot) in
            let usersData = snapshot.value as! NSDictionary
            
            for userDataDictionary in usersData {
                let userData = userDataDictionary.value as! NSDictionary
                let userID = userData["id"] as! String
                
                if userData["observedUsers"] != nil {
                    let observedUsers = userData["observedUsers"] as! NSDictionary
                    for observedUserDictionary in observedUsers {
                        let observedUserData = observedUserDictionary.value as! NSDictionary
                        let observedUserID = observedUserData["id"] as! String
                        
                        if currentUser == observedUserID && observedUserData["geotifications"] != nil {
                            let geotifications = observedUserData["geotifications"] as! NSDictionary
                            for geotificationDictionary in geotifications {
                                let geotificationData = geotificationDictionary.value as! NSDictionary
                                
                                let identifier = geotificationDictionary.key as! String
                                let latitude = CLLocationDegrees(geotificationData["latitude"] as! String)!
                                let longitude = CLLocationDegrees(geotificationData["longitude"] as! String)!
                                let radius = Double(geotificationData["radius"] as! String)!
                                let note = geotificationData["note"] as! String
                                let eventType: EventType = (geotificationData["eventType"] as! String == "onEntry") ? .onEntry : .onExit
                                
                                let geotification = Geotification(latitude: latitude, longitude: longitude, radius: radius, identifier: identifier, note: note, eventType: eventType)
                                
                                if let topVC = UIApplication.topViewController() {
                                    geofencing.startMonitoring(controller: topVC, geotification: geotification)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

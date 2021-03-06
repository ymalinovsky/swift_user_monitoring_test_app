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
    
    static let singleton = FirebaseRealtimeDatabase()
    
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
        let geotification = ["observedUserID": userID, "latitude": String(describing: latitude), "longitude": String(describing: longitude), "radius": String(describing: radius), "note": note , "eventType": String(describing: eventType)]
        
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
    
    func addGeofenceNotificationAboutObservingUser(userID: String, identifier: String) {
        let geotificationsUserDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("geotifications").child(identifier)
        geotificationsUserDB.observeSingleEvent(of: .value) { (snapshot) in
            let geotificationData = snapshot.value as! NSDictionary
            let preparedGeotificationData = firebaseHelper.prepareGeotificationData(geotificationData: geotificationData)
            let observedUserID = preparedGeotificationData.observedUserID
            
            let geofenceNotificationDB = Database.database().reference().child("users").child(getValidUserID(userID: observedUserID)).child("geofenceNotification")
            let messages = "\(preparedGeotificationData.eventType.rawValue) Radius \(preparedGeotificationData.radius) m"
            
            let geofenceNotification = ["observedUserID": observedUserID, "messages": messages]

            geofenceNotificationDB.childByAutoId().setValue(geofenceNotification) { (error, ref) in
                if error != nil {
                    print(error!)
                }
            }
            
            self.getFCMTokenAndSendNotification(observedUserID: observedUserID, title: userID, body: messages)
        }
    }
    
    func setFCMToken(userID: String, fcmToken: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("fcm")
        
        let fcmToken = ["fcmToken": fcmToken]
        
        userDB.setValue(fcmToken) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
    
    func getFCMTokenAndSendNotification(observedUserID: String, title: String, body: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: observedUserID)).child("fcm")
        userDB.observeSingleEvent(of: .value) { (snapshot) in
            let fcmData = snapshot.value as! NSDictionary
            
            let fcmToken = fcmData["fcmToken"] as! String
            
            firebaseMessaging.sendUserNotification(fcmToken: fcmToken, title: title, body: body)
        }
    }
}

//
//  FirebaseRealtimeDatabaseObserve.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class FirebaseRealtimeDatabaseObserve {
    func newUserObserver() {
        let userDB = Database.database().reference().child("users")
        userDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            let userID = userData["id"] as! String
            
            var latitude = String()
            var longitude = String()
            if userData["coordinates"] != nil {
                let coordinates = userData["coordinates"] as! NSDictionary
                latitude = String(describing: coordinates["latitude"]!)
                longitude = String(describing: coordinates["longitude"]!)
            }
            
            if !fullUsersList.contains(where: { $0.userID == userID }) {
                if latitude.isEmpty && longitude.isEmpty {
                    fullUsersList.append(MonitoringUser(userID: userID, latitude: nil, longitude: nil))
                } else {
                    fullUsersList.append(MonitoringUser(userID: userID, latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)))
                }
                
                if userID == currentUser {
                    self.observedUserObserver(userID: userID)
                }
            }
        })
    }
    
    func observedUserObserver(userID: String) {
        let observedUsersDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("observedUsers")
        
        observedUsersDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            let observedUserID = userData["id"] as! String
            
            if observedUserID != currentUser {
                if let index = fullUsersList.index(where: { $0.userID == observedUserID}) {
                    self.userCoordinatesObserver(userID: observedUserID)
                    self.observingUserGeotificationObserver(userID: userID, observedUserID: observedUserID)
                    
                    observedUsersListByCurrentUser.append(MonitoringUser(userID: observedUserID, latitude: fullUsersList[index].latitude, longitude: fullUsersList[index].longitude))
                    NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
                }
            }
        })
    }
    
    func checkNewUserObserver(userID: String) {
        let userDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("checkNewUsersObserve")
        
        userDB.observe(.childAdded, with: { (snapshot) -> Void in
            let userData = snapshot.value as! NSDictionary
            
            let observedUserID = userData["id"] as! String
            
            NotificationCenter.default.post(name: .agreeUserObservingOrNot, object: nil, userInfo: [observedUserID: ["observedUserID": observedUserID]])
        })
    }
    
    func userCoordinatesObserver(userID: String) {
        let coordinatesDB = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("coordinates")
        
        coordinatesDB.observe(.childChanged, with: { (snapshot) -> Void in
            switch snapshot.key {
            case "latitude":
                if let userIndex = fullUsersList.index(where: { $0.userID == userID}) {
                    let latitude = CLLocationDegrees(String(describing: snapshot.value!))
                    let longitude = fullUsersList[userIndex].longitude
                    
                    fullUsersList[userIndex] = MonitoringUser(userID: userID, latitude: latitude, longitude: longitude)
                }
            case "longitude":
                if let userIndex = fullUsersList.index(where: { $0.userID == userID}) {
                    let latitude = fullUsersList[userIndex].latitude
                    let longitude = CLLocationDegrees(String(describing: snapshot.value!))
                    
                    fullUsersList[userIndex] = MonitoringUser(userID: userID, latitude: latitude, longitude: longitude)
                }
            default: break
            }
            
            NotificationCenter.default.post(name: .googleMapsVCMarkerMustBeReload, object: nil, userInfo: nil)
        })
    }
    
    func observingUserGeotificationObserver(userID: String, observedUserID: String) {
        let db = Database.database().reference().child("users").child(getValidUserID(userID: userID)).child("observedUsers").child(getValidUserID(userID: observedUserID)).child("geotifications")
        
        db.observe(.childAdded, with: { (snapshot) -> Void in
            if let userIndex = observedUsersListByCurrentUser.index(where: { $0.userID == observedUserID}) {
                let geotificationData = snapshot.value as! NSDictionary
                
                let identifier = snapshot.key
                let latitude = CLLocationDegrees(geotificationData["latitude"] as! String)!
                let longitude = CLLocationDegrees(geotificationData["longitude"] as! String)!
                let radius = Double(geotificationData["radius"] as! String)!
                let note = geotificationData["note"] as! String
                let eventType: EventType = (geotificationData["eventType"] as! String == "onEntry") ? .onEntry : .onExit
                
                let geotification = Geotification(latitude: latitude, longitude: longitude, radius: radius, identifier: identifier, note: note, eventType: eventType)
                
                if observedUsersListByCurrentUser[userIndex].geotifications != nil {
                    observedUsersListByCurrentUser[userIndex].geotifications!.append(geotification)
                } else {
                    observedUsersListByCurrentUser[userIndex].geotifications = [geotification]
                }
                
                NotificationCenter.default.post(name: .googleMapsVCMarkerMustBeReload, object: nil, userInfo: nil)
            }
        })
    }
}

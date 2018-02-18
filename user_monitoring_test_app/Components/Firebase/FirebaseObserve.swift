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
            
            observedUsersListByCurrentUser.append(MonitoringUser(userID: userID, latitude: nil, longitude: nil))
            NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
        })
    }
    
    func userCoordinatesObserver(userID: String) {
        let coordinatesDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!).child("coordinates")
        
        coordinatesDB.observe(.childChanged, with: { (snapshot) -> Void in
            switch snapshot.key {
            case "latitude":
                if let index = fullUsersList.index(where: { $0.userID == userID}) {
                    let latitude = CLLocationDegrees(String(describing: snapshot.value!))
                    let longitude = fullUsersList[index].longitude
                    
                    fullUsersList[index] = MonitoringUser(userID: userID, latitude: latitude, longitude: longitude)
                }
            case "longitude":
                if let index = fullUsersList.index(where: { $0.userID == userID}) {
                    let latitude = fullUsersList[index].latitude
                    let longitude = CLLocationDegrees(String(describing: snapshot.value!))
                    
                    fullUsersList[index] = MonitoringUser(userID: userID, latitude: latitude, longitude: longitude)
                }
            default: break
            }
            
//            NotificationCenter.default.post(name: .userObservedListVCTableViewMustBeReload, object: nil, userInfo: nil)
        })
    }
}

//
//  FirebaseHelper.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 01.03.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import CoreLocation

class FirebaseHelper {
    func prepareGeotificationData(geotificationData: NSDictionary) -> (observedUserID: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, note: String, eventType: EventType) {
        let observedUserID = geotificationData["observedUserID"] as! String
        let latitude = CLLocationDegrees(geotificationData["latitude"] as! String)!
        let longitude = CLLocationDegrees(geotificationData["longitude"] as! String)!
        let radius = Double(geotificationData["radius"] as! String)!
        let note = geotificationData["note"] as! String
        let eventType: EventType = (geotificationData["eventType"] as! String == "onEntry") ? .onEntry : .onExit
        
        return (observedUserID: observedUserID, latitude, longitude, radius, note, eventType)
    }
}

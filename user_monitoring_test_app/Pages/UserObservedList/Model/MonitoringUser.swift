//
//  MonitoringUser.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import CoreLocation

struct MonitoringUser {
    let userID: String
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var geotification: [Geotification]?
    
    init(userID: String, latitude: CLLocationDegrees?, longitude: CLLocationDegrees?, geotification: [Geotification]? = nil) {
        self.userID = userID
        self.latitude = latitude
        self.longitude = longitude
        self.geotification = geotification
    }
}

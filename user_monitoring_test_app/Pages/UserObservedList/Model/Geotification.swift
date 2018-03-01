//
//  Geotification.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 26.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import CoreLocation

enum EventType: String {
    case onEntry = "On Entry"
    case onExit = "On Exit"
}

struct Geotification {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let radius: Double
    let identifier: String
    let note: String
    let eventType: EventType
    
    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, identifier: String, note: String, eventType: EventType) {
        self.latitude = latitude
        self.longitude = longitude
        self.radius = radius
        self.identifier = identifier
        self.note = note
        self.eventType = eventType
    }
}

//
//  AddGeotification.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 26.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class AddGeotification {
    
    var controller: AddGeotificationViewController
    
    init(controller: AddGeotificationViewController) {
        self.controller = controller
    }
    
    func addGeotification(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, identifier: String, note: String, eventType: EventType) {
    
    }
}

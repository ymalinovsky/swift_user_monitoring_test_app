//
//  MonitoringUser.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation

struct MonitoringUser {
    let userID: String
    let userName: String
    
    init(userID: String, userName: String) {
        self.userID = userID
        self.userName = userName
    }
}

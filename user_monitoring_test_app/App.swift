//
//  App.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation

let firebaseAuth = FirebaseAuth()

var fullUsersList = [MonitoringUser]()
var observedUsersListByCurrentUser = [MonitoringUser]()
var usersListWhoMonitoringCurrentUser = [MonitoringUser]()

var currentUser = String()

extension Notification.Name {
    static let loginSuccess = Notification.Name("loginSuccess")
}

//
//  App.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit

struct App {
    static let currentUserKeyForUserDefaults = "currentUserKey"
    static let currentUserPasswordKeyForUserDefaults = "currentUserPasswordKey"
}

let firebaseAuth = FirebaseAuth()
let firebaseDatabase = FirebaseDatabase()
let firebaseObserve = FirebaseObserve()

var fullUsersList = [MonitoringUser]()
var observedUsersListByCurrentUser = [MonitoringUser]()
var usersListByCurrentUserObserving = [MonitoringUser]()

var currentUser = String()

extension Notification.Name {
    static let loginSuccess = Notification.Name("loginSuccess")
    static let userObservedListVCTableViewMustBeReload = Notification.Name("userObservedListVCTableViewMustBeReload")
    static let whoObservingCurrentUserVCTableViewMustBeReload = Notification.Name("whoObservingCurrentUserVCTableViewMustBeReload")
    static let googleMapsVCMarkerMustBeReload = Notification.Name("googleMapsVCMarkerMustBeReload")
    static let agreeUserObservingOrNot = Notification.Name("agreeUserObservingOrNot")
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

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

let firebaseAuth = FirebaseAuthentication()
let firebaseDatabase = FirebaseRealtimeDatabase()
let firebaseObserve = FirebaseRealtimeDatabaseObserve()
let firebaseStorage = FirebaseStorage()

var fullUsersList = [MonitoringUser]()
var observedUsersListByCurrentUser = [MonitoringUser]()
var usersListByCurrentUserObserving = [MonitoringUser]()

var currentUser = String()

var hamburgerMenu = HamburgerMenu()

extension Notification.Name {
    static let loginSuccess = Notification.Name("loginSuccess")
    static let userObservedListVCTableViewMustBeReload = Notification.Name("userObservedListVCTableViewMustBeReload")
    static let whoObservingCurrentUserVCTableViewMustBeReload = Notification.Name("whoObservingCurrentUserVCTableViewMustBeReload")
    static let googleMapsVCMarkerMustBeReload = Notification.Name("googleMapsVCMarkerMustBeReload")
    static let agreeUserObservingOrNot = Notification.Name("agreeUserObservingOrNot")
    static let userObservedListVCRemoveItemFromAssignUserObserveToUserQueue = Notification.Name("userObservedListVCRemoveItemFromAssignUserObserveToUserQueue")
    static let profileImageDownloadCompletedSuccessfully = Notification.Name("profileImageDownloadCompletedSuccessfully")
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

func getValidUserID(userID: String) -> String {
    return userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!
}

func resizeImage(image: UIImage, toSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = toSize.width  / size.width
    let heightRatio = toSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


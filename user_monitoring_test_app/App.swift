//
//  App.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import UserNotifications
import Firebase

struct App {
    static let currentUserKeyForUserDefaults = "currentUserKey"
    static let currentUserPasswordKeyForUserDefaults = "currentUserPasswordKey"
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let firebaseHelper = FirebaseHelper.singleton
let firebaseAuth = FirebaseAuthentication.singleton
let firebaseDatabase = FirebaseRealtimeDatabase.singleton
let firebaseObserve = FirebaseRealtimeDatabaseObserve.singleton
let firebaseStorage = FirebaseStorage.singleton

var fullUsersList = [MonitoringUser]()
var observedUsersListByCurrentUser = [MonitoringUser]()
var usersListByCurrentUserObserving = [MonitoringUser]()

var currentUser = String()

let hamburgerMenu = HamburgerMenu()

let geofencing = Geofencing()

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLCircularRegion {
            geofencing.handleGeofencingEvent(forRegion: region, isEnterToRegion: true)
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLCircularRegion {
            geofencing.handleGeofencingEvent(forRegion: region, isEnterToRegion: false)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            firebaseDatabase.saveUserLocations(userID: currentUser, location: location)
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        print("\(hour):\(minutes):\(seconds) - locations: \(locations.count)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        if let error = error {
            print(error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways:
            print("Location status is OK always.")
        case .authorizedWhenInUse:
            print("Location status is OK when app in use.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        print("Firebase registration token: \(fcmToken)")
    }
}

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

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
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

func showAlert(controller: UIViewController, withTitle title: String?, message: String?) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alert.addAction(action)
    controller.present(alert, animated: true, completion: nil)
}


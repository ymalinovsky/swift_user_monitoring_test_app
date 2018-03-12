//
//  FirebaseAuthentication.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuthentication {
    
    static let singleton = FirebaseAuthentication()
    
    func emailRegistration(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                firebaseDatabase.addNewUser(userID: email)
                
                UserDefaults.standard.set(email, forKey: App.currentUserKeyForUserDefaults)
                UserDefaults.standard.set(password, forKey: App.currentUserPasswordKeyForUserDefaults)
                
                currentUser = email
                
                if let fcmToken = Messaging.messaging().fcmToken {
                    firebaseDatabase.setFCMToken(userID: currentUser, fcmToken: fcmToken)
                }

                firebaseObserve.checkNewUserObserver(userID: currentUser)
                
                NotificationCenter.default.post(name: .loginSuccess, object: nil, userInfo: nil)
            }
        })
    }
    
    func emailLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
                firebaseDatabase.addNewUser(userID: email)
                
                UserDefaults.standard.set(email, forKey: App.currentUserKeyForUserDefaults)
                UserDefaults.standard.set(password, forKey: App.currentUserPasswordKeyForUserDefaults)
                
                currentUser = email
                
                if let fcmToken = Messaging.messaging().fcmToken {
                    firebaseDatabase.setFCMToken(userID: currentUser, fcmToken: fcmToken)
                }
                
                firebaseObserve.checkNewUserObserver(userID: currentUser)
                
                NotificationCenter.default.post(name: .loginSuccess, object: nil, userInfo: nil)
            }
        })
    }
}

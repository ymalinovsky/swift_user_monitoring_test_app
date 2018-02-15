//
//  FirebaseAuth.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseAuth {
    func emailRegistration(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
//                self.addNewUser(userID: email)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let chatsNC = storyboard.instantiateViewController(withIdentifier: "userObservedListNavigationController")
                currentUser = email
                
                self.signInVC.present(chatsNC, animated: true)
            }
        })
    }
    
    func emailLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error!)
            }
            else {
//                self.addNewUser(userID: email)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let chatsNC = storyboard.instantiateViewController(withIdentifier: "userObservedListNavigationController")
                currentUser = email
                
                self.loginVC.present(chatsNC, animated: true)
            }
        })
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homepageNC = storyboard.instantiateViewController(withIdentifier: "homepageNavigationController")
            currentUser = String()
            
            self.chatVC.present(homepageNC, animated: true)
        } catch {
            print(error)
        }
    }
}

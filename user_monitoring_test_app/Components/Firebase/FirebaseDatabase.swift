//
//  FirebaseDatabase.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDatabase {
    func addNewUser(userID: String) {
        let userDB = Database.database().reference().child("users").child(userID.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.alphanumerics)!)
        
        userDB.child("id").setValue(userID) { (error, ref) in
            if error != nil {
                print(error!)
            }
        }
    }
}

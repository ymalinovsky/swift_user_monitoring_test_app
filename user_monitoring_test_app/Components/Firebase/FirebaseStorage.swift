//
//  FirebaseStorage.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 22.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import Firebase

class FirebaseStorage {
    func uploadProfileImage(filePath: URL, userID: String) {
        let storageRef = Storage.storage().reference()
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let uploadTask = storageRef.child(getValidUserID(userID: userID)).child("profile.png").putFile(from: filePath, metadata: metadata)

        uploadTask.observe(.success) { snapshot in
            print("Upload completed successfully")
        }
    }
}

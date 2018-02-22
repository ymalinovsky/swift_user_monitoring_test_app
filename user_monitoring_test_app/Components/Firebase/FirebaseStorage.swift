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
    
    func downloadProfileImage(userID: String) {
        let storageRef = Storage.storage().reference()
        
        let fileName = "profile"
        let fileExtension = "png"
        
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = dirPaths.first {
            let dataFile = dirPath.appendingPathComponent("\(fileName).\(fileExtension)").path
            
            if fileManager.fileExists(atPath: dataFile) {
                try! fileManager.removeItem(atPath: dataFile)
            }
            
            let downloadTask = storageRef.child(getValidUserID(userID: userID)).child("profile.png").write(toFile: URL(fileURLWithPath: dataFile))
            
            downloadTask.observe(.success) { snapshot in
                NotificationCenter.default.post(name: .profileImageDownloadCompletedSuccessfully, object: nil, userInfo: [userID: ["profileImageFilePath": dataFile]])
            }
            
            downloadTask.observe(.failure) { snapshot in
                print("File doesn't exist")
            }
        }
    }
}

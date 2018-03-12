//
//  FirebaseCloudMessaging.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 12.03.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation

class FirebaseCloudMessaging {
    
    static let singleton = FirebaseCloudMessaging()
    
    let sendURL = URL(string: "https://fcm.googleapis.com/fcm/send")!
    
    func getFCMURLRequest(url: URL, fcmToken: String) -> URLRequest {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let authorizationBearerSchema = "key=AAAAtQLrBSo:APA91bHn2eMhTEA0fova05holi5IGWvBPsdg4hKrPpW4_YSN3VoEHKvdKu3H3POEeNB_UqT--PiOr1UiGrQLHS9OQgdvDHVqrqjQyJTA_M5_Yd8BANum6iAb-v5L0QXp7TK6UNO1_3AQ"
        request.setValue(authorizationBearerSchema, forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    func sendUserNotification(fcmToken: String, title: String, body: String) {
        var request = self.getFCMURLRequest(url: self.sendURL, fcmToken: fcmToken)
        
        let notificationDataArray = [
            "\"title\": \"\(title)\"",
            "\"body\": \"\(body)\""
        ]
        let notificationDataString = "{ " + notificationDataArray.joined(separator: ", ") + " }"
        
        let notificationArray = [
            "\"notification\": \(notificationDataString)",
            "\"priority\": \"high\"",
            "\"to\": \"\(fcmToken)\""
        ]
        let notificationString = "{ " + notificationArray.joined(separator: ", ") + " }"
        
        request.httpBody = notificationString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard error == nil, let httpResponse = response as? HTTPURLResponse else {
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Unpredicted network error.")
                }
                
                return
            }
            
            switch httpResponse.statusCode {
            case 200: // 200 OK
                print("Success send notification.")
            default:
                print("Unpredicted API error.")
            }
        }).resume()
    }
}

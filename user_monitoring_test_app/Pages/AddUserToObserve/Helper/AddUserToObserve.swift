//
//  AddUserToObserve.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation

class AddUserToObserve {
    
    func getUsersObserveList() -> [MonitoringUser] {
        var usersObserveList = [MonitoringUser]()
        
        fullUsersList.forEach { (user) in
            if !observedUsersListByCurrentUser.contains(where: { $0.userID == user.userID }) && user.userID != currentUser {
                usersObserveList.append(user)
            }
        }
        
        return usersObserveList
    }
}

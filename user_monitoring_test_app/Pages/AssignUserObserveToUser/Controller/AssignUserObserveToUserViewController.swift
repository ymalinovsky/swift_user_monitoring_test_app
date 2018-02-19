//
//  AssignUserObserveToUserViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 19.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class AssignUserObserveToUserViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!

    var observedUserID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "User \"\(observedUserID)\" want monitoring you.\n\n\nAre you agree?"
    }

    @IBAction func yesButtonAction(_ sender: UIButton) {
        firebaseDatabase.removeNewUsersObserve(userID: currentUser, observedUserID: observedUserID)
        firebaseDatabase.addObservedUser(userID: currentUser, observedUserID: observedUserID)
        dismiss(animated: true)
    }
    
    @IBAction func noButtonAction(_ sender: UIButton) {
        firebaseDatabase.removeNewUsersObserve(userID: currentUser, observedUserID: observedUserID)
        dismiss(animated: true)
    }
    
}

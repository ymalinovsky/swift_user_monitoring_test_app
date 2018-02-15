//
//  LoginViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func LoginButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            firebaseAuth.emailLogin(email: email, password: password)
        }
    }
    
}

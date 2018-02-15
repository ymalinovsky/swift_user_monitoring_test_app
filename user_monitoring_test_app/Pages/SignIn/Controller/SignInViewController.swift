//
//  SignInViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 15.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: .loginSuccess, object: nil)
    }
    
    @objc func loginSuccess(notification: NSNotification) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatsNC = storyboard.instantiateViewController(withIdentifier: "userObservedListNavigationController")
        
        present(chatsNC, animated: true)
    }

    @IBAction func SignInButtonAction(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            firebaseAuth.emailRegistration(email: email, password: password)
        }
    }
}


//
//  MenuViewController.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 21.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userTitleLabel: UILabel!
    
    let menuRows = ["Photo"]
    
    var menuCellIdentifier = "menuCell"
    
    var helper: Menu!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagePicker.delegate = self
        
        helper = Menu(controller: self)
        
        userTitleLabel.text = currentUser
        
        helper.prepareProfileImageView()
        
        firebaseStorage.downloadProfileImage(userID: currentUser)
        
        NotificationCenter.default.addObserver(self, selector: #selector(profileImageDownloadCompletedSuccessfully), name: .profileImageDownloadCompletedSuccessfully, object: nil)
    }

    @objc func profileImageDownloadCompletedSuccessfully(notification: NSNotification) {
        if let notificationData = notification.userInfo?.first?.value {
            let data = notificationData as! [String: NSDictionary]
            
            if let profileImageFilePath = data[currentUser]?["profileImageFilePath"] {
                if let profileImage = UIImage(contentsOfFile: profileImageFilePath as! String) {
                    helper.setProfileImage(image: profileImage)
                }
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: menuCellIdentifier)!
        
        cell.textLabel?.text = menuRows[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: helper.gerCameraPopup()
        default: break
        }
    }
    
    // MARK:  UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let resizedChosenImage = resizeImage(image: chosenImage, toSize: CGSize(width: profileImageView.frame.size.width, height: profileImageView.frame.size.height))
        helper.setProfileImage(image: resizedChosenImage)
        
        if let filePath = helper.getProfileImageURLPath() {
            firebaseStorage.uploadProfileImage(filePath: filePath, userID: currentUser)
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}

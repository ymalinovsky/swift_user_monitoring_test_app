//
//  Menu.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 22.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit

class Menu {
    
    let controller: MenuViewController
    
    init(controller: MenuViewController) {
        self.controller = controller
    }
    
    func prepareProfileImageView() {
        controller.profileImageView.image = UIImage(named: "profile")
        
        controller.profileImageView.layer.borderWidth = 1
        controller.profileImageView.layer.masksToBounds = false
        controller.profileImageView.layer.borderColor = UIColor.clear.cgColor
        controller.profileImageView.layer.cornerRadius = controller.profileImageView.frame.height / 2
        controller.profileImageView.clipsToBounds = true
    }
    
    func gerCameraPopup() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Photo from Album", style: .default, handler: { (action: UIAlertAction!) in
            self.getPhotoFromLibrary()
        }))
        
        alertController.addAction(UIAlertAction(title: "Take a Photo", style: .default, handler: { (action: UIAlertAction!) in
            self.getPhotoFromCamera()
        }))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.modalPresentationStyle = .popover
            controller.present(alertController, animated: true, completion: nil)
            
            if let popoverPresentationController = alertController.popoverPresentationController {
                popoverPresentationController.sourceView = controller.view
            }
        } else {
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    
    func getPhotoFromLibrary() {
        controller.imagePicker.allowsEditing = false
        controller.imagePicker.sourceType = .photoLibrary
        controller.imagePicker.modalPresentationStyle = .popover
        controller.present(controller.imagePicker, animated: true, completion: nil)
        controller.imagePicker.popoverPresentationController?.sourceView = controller.view
    }
    
    func getPhotoFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            controller.imagePicker.allowsEditing = false
            controller.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            controller.imagePicker.cameraCaptureMode = .photo
            controller.imagePicker.modalPresentationStyle = .fullScreen
            
            controller.present(controller.imagePicker, animated: true)
        } else {
            let alertController = UIAlertController(title: "Camera not available", message: "Sorry, this app has no access to the camera", preferredStyle: .alert)
            let okAlertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAlertAction)
            
            controller.present(alertController, animated: true)
        }
    }
}

//
//  HamburgerMenu.swift
//  user_monitoring_test_app
//
//  Created by Yan Malinovsky on 21.02.2018.
//  Copyright © 2018 Yan Malinovsky. All rights reserved.
//

import Foundation
import UIKit

class HamburgerMenu {
    
    private let centerPanelExpandedOffset: CGFloat = 60
    
    func animateLeftPanel(centerVC: UIViewController, shouldExpand: Bool) {
        if shouldExpand {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: centerVC.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: 0)
        }
    }
    
    func animateRightPanel(centerVC: UIViewController, shouldExpand: Bool) {
        if shouldExpand {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: -centerVC.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: 0)
        }
    }
    
    func addLeftSidePanel(centerVC: UIViewController, leftVC: UIViewController) {
        leftVC.view.frame = centerVC.view.bounds
        leftVC.view.frame.origin.x = -leftVC.view.frame.size.width + centerPanelExpandedOffset
        leftVC.view.frame.size.width -= centerPanelExpandedOffset
        
        leftVC.willMove(toParentViewController: centerVC)
        centerVC.view.addSubview(leftVC.view)
        centerVC.addChildViewController(leftVC)
        leftVC.didMove(toParentViewController: centerVC)
    }
    
    func addRightSidePanel(centerVC: UIViewController, rightVC: UIViewController) {
        rightVC.view.frame = centerVC.view.bounds
        rightVC.view.frame.origin.x = rightVC.view.frame.size.width
        rightVC.view.frame.size.width -= centerPanelExpandedOffset
        
        rightVC.willMove(toParentViewController: centerVC)
        centerVC.view.addSubview(rightVC.view)
        centerVC.addChildViewController(rightVC)
        rightVC.didMove(toParentViewController: centerVC)
    }
    
    private func animateCenterPanelXPosition(centerVC: UIViewController, targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            centerVC.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}

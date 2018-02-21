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
    
    func animateLeftPanel(leftVC: UIViewController, centerVC: UIViewController, shouldExpand: Bool) {
        if shouldExpand {
            addChildSidePanelController(centerVC: centerVC, childSideVC: leftVC)
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: centerVC.view.frame.width - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: 0) { _ in
                leftVC.view.removeFromSuperview()
            }
        }
    }
    
    func animateRightPanel(rightVC: UIViewController, centerVC: UIViewController, shouldExpand: Bool) {
        if shouldExpand {
            addChildSidePanelController(centerVC: centerVC, childSideVC: rightVC)
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: -centerVC.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(centerVC: centerVC, targetPosition: 0) { _ in
                rightVC.view.removeFromSuperview()
            }
        }
    }
    
    private func addChildSidePanelController(centerVC: UIViewController, childSideVC: UIViewController) {
        centerVC.view.insertSubview(childSideVC.view, at: -1)

        centerVC.addChildViewController(childSideVC)
        childSideVC.didMove(toParentViewController: centerVC)
    }
    
    private func animateCenterPanelXPosition(centerVC: UIViewController, targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            centerVC.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
}

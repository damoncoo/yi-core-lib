//
//  UIViewController+Ext.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import UIKit

public extension UIViewController {
    
    static func visibleNavigationController() -> UINavigationController? {
        
        if let tabController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            return tabController.selectedViewController as? UINavigationController
        }
        return nil
    }
}


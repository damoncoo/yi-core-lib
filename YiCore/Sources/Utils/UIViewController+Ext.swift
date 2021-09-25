//
//  UIViewController+Ext.swift
//  Yi
//
//  Created by Darcy on 2021/5/26.
//

import UIKit

public extension UIViewController {
    
    static func visibleNavigationController() -> UINavigationController? {
        
        let root = UIApplication.shared.keyWindow?.rootViewController
        
        if let tabController = root as? UITabBarController {
            return tabController.selectedViewController as? UINavigationController
        }
        if let nav = root as? UINavigationController {
            return nav
        }
        return nil
    }
    
    static func visibleViewController() -> UIViewController? {
        
        let root = UIApplication.shared.keyWindow?.rootViewController
        
        if let tabController = root as? UITabBarController {
            let nav = tabController.selectedViewController as? UINavigationController
            return nav?.viewControllers.last
        }
        if let nav = root as? UINavigationController {
            return nav.viewControllers.last
        }
        return root
    }
    
}


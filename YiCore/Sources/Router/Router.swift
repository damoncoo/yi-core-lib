//
//  Router.swift
//  Yi
//
//  Created by Cxy on 2020/11/2.
//

import Foundation
import UIKit

public protocol RouteFatory  {
    
   static func initWithData(data: Dictionary<String, Any>?) -> UIViewController?
}

open class SNRouteViewController : SNBaseViewController, RouteFatory {

    deinit {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public static func initWithData(data: Dictionary<String, Any>?) -> UIViewController? {
        
        let vc = self.init()
        return vc.validate(data: data)
    }
}


public class SNRouter : NSObject {
    
    public static var defalut = SNRouter()
        
    private var dataMap = Dictionary<String, RouteFatory.Type>()

    override init() {
        super.init()
    }
        
    public func registerPage (path: String, for aClass: RouteFatory.Type)   {
        self.dataMap[path] = aClass
    }
    
    @discardableResult
    public func routePage(page : String, for data: Dictionary<String, Any>?) -> Bool {
        let r = self.dataMap[page]
        if r != nil {
            let type = r!.self
            let vc = type.initWithData(data: data)
            if vc != nil {
                vc?.hidesBottomBarWhenPushed = true
                UIViewController.visibleNavigationController()?.pushViewController(vc!, animated: true)
                return true
            }
        }
        return false
    }
    
}


//
//  UIColor.swift
//  Yi
//
//  Created by Cxy on 2020/10/23.
//

import Foundation
import UIKit
import SwifterSwift

public extension UIColor {
    
    static var themeColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: String.themeStr())!, color2: UIColor(hexString: "#191919")!)
    }
    
    static var themeColor2 : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: String.themeStr())!, color2: UIColor(hexString: "#333333")!)
    }
    
    static var themeColor3 : UIColor {
        return UIColor(hexString: String.themeStr())!
    }

    static var contentColor : UIColor {
        return UIColor(hexString: "#2B2B2B")!
    }
    
    static var sepColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#DDDDDD")!, color2: UIColor(hexString: "#272727")!)
    }
    
    static var sepColor2 : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#DDDDDD")!, color2: UIColor(hexString: "#444444")!)
    }
    
    static var pageBgColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#FFFFFF")!, color2: UIColor(hexString: "#0E0E0E")!)
    }
    
    static var pageBgColor2 : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#F2F3F5")!, color2: UIColor(hexString: "#111111")!)
    }
    
    static var pageBgColor3 : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#F2F3F5")!, color2: UIColor(hexString: "#333333")!)
    }
    
    static var tabBarColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#F7F8F9")!, color2: UIColor(hexString: "#191919")!)
    }
    
    static var mainTextColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#555555")!, color2: UIColor(hexString: "#AAAAAA")!)
    }
    
    static var mainTextColor2 : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#191919")!, color2: UIColor(hexString: "#AAAAAA")!)
    }
    
    static var subTextColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#999999")!, color2: UIColor(hexString: "#999999")!)
    }
    
    static var themeTextColor : UIColor {
        return UIColor.dynamicColor(color1: UIColor(hexString: "#F2F3F5")!, color2: UIColor(hexString: "#F2F3F5")!)
    }
        
    static func dynamicColor(color1 : UIColor, color2 : UIColor) -> UIColor {
            
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                if traitCollection.userInterfaceStyle == .light  {
                    return color1
                }
                return color2
            }
        } else {
            return color1
        }
    }
}

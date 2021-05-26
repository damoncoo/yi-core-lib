//
//  UIImage.swift
//  Yi
//
//  Created by Darcy on 2020/10/30.
//

import UIKit

extension UIImage {

    static func imageWithColor(color: UIColor) -> UIImage {
        
        let rect = CGRect(origin: .zero, size: CGSize.init(width: 1, height: 1))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }
    
}

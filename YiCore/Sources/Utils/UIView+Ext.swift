//
//  UIView+Ext.swift
//  Yi
//
//  Created by Cxy on 2021/1/8.
//

import UIKit
import SnapKit

extension UIView {
    
    func safeBottom() -> ConstraintItem {
        
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp.bottom
        } else {
            return self.snp.bottom
        }
    }
    
    func safeAreaEdges() -> UIEdgeInsets {
        
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func solidSafeAreaEdges() -> UIEdgeInsets {
        
        if #available(iOS 11.0, *) {
            var insets =  self.safeAreaInsets
            if insets.top == 0 {
                insets.top = 20
            }
            return insets
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}

extension UIView {
    
    struct Keys {
        
        static var loadingKey = "cn.seungyu.yi.loading"
    }
    
    private var loadingView: ProgressView? {
        get { return objc_getAssociatedObject(self, &Keys.loadingKey)  as? ProgressView  }
        set { objc_setAssociatedObject(self, &Keys.loadingKey, newValue, .OBJC_ASSOCIATION_RETAIN) }
    }
    
    func showLoading()  {
        
        if self.loadingView == nil {
            let progress = ProgressView(colors: [.red, .systemGreen, .systemBlue], lineWidth: 5)
            progress.translatesAutoresizingMaskIntoConstraints = false
            self.loadingView = progress
        }
        
        guard let progress = self.loadingView else {
            return
        }
        
        progress.isAnimating = true
        self.addSubview(progress)
        progress.snp.makeConstraints { (make) in
            make.center.equalTo(self.snp.center)
            make.width.height.equalTo(50)
        }
    }
    
    func stopLoading()  {
        
        guard let progress = self.loadingView else {
            return
        }
        progress.isAnimating = false
        progress.removeFromSuperview()
    }
    
}


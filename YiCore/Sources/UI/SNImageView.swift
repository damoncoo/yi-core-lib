//
//  SNImageView.swift
//  Yi
//
//  Created by Darcy on 2021/3/27.
//

import UIKit

public struct SNImage : SNMultiImage {
    
    public var normalImage : UIImage
    public var darkImage : UIImage?
    
    public func image() -> UIImage {
        if #available(iOS 13.0, *) {
            let dark = UITraitCollection.current.userInterfaceStyle == .dark
            if dark {
                return self.darkImage ?? self.normalImage
            }
        }
        return self.normalImage
    }
}

public class SNImageView: UIImageView {
        
    public var snImage : SNMultiImage! {
        
        didSet {
            self.updateImage()
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateImage()
    }
    
    func updateImage()  {
        self.image = self.snImage.image()
    }
}

public class SNButton: UIButton {
        
    public var snImage : SNMultiImage! {
        didSet {
            self.updateImage()
        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateImage()
    }
    
    func updateImage()  {
        self.setImage(self.snImage.image(), for: .normal)
    }
}


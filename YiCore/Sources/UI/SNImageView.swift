//
//  SNImageView.swift
//  Yi
//
//  Created by Darcy on 2021/3/27.
//

import UIKit

struct SNImage : SNMultiImage {
    
    var normalImage : UIImage
    var darkImage : UIImage?
    
    func image() -> UIImage {
        if #available(iOS 13.0, *) {
            let dark = UITraitCollection.current.userInterfaceStyle == .dark
            if dark {
                return self.darkImage ?? self.normalImage
            }
        }
        return self.normalImage
    }
}

class SNImageView: UIImageView {
        
    var snImage : SNMultiImage! {
        
        didSet {
            self.updateImage()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateImage()
    }
    
    func updateImage()  {
        self.image = self.snImage.image()
    }
}

class SNButton: UIButton {
        
    var snImage : SNMultiImage! {
        didSet {
            self.updateImage()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateImage()
    }
    
    func updateImage()  {
        self.setImage(self.snImage.image(), for: .normal)
    }
}


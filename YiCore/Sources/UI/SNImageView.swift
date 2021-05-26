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
    
    public init(normalImage : UIImage, darkImage : UIImage?) {
        self.normalImage = normalImage
        self.darkImage = darkImage
    }
    
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
        
    public init() {
        super.init(frame: CGRect.zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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


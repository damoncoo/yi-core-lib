//
//  StrokeAnimation.swift
//  CircularProgress
//
//  Created by Zafar on 10/3/20.
//  Copyright © 2020 Zafar. All rights reserved.
//
import UIKit
import QuartzCore

class StrokeAnimation: CABasicAnimation {
    
    override init() {
        super.init()
    }
    
    init(type: StrokeType,
         beginTime: Double = 0.0,
         fromValue: CGFloat,
         toValue: CGFloat,
         duration: Double) {
        
        super.init()
        
        self.keyPath = type == .start ? "strokeStart" : "strokeEnd"
        
        self.beginTime = beginTime
        self.fromValue = fromValue
        self.toValue = toValue
        self.duration = duration
        self.timingFunction = .init(name: CAMediaTimingFunctionName.easeInEaseOut)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum StrokeType {
        case start
        case end
    }
}

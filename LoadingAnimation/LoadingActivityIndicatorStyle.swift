//
//  LoadingActivityIndicatorStyle.swift
//  LoadingAnimation
//
//  Created by David on 07/08/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

public enum LoadingActivityIndicatorType {
    case circular
}

class LoadingActivityIndicatorStyle: NSObject {
    
    static let shared = LoadingActivityIndicatorStyle()
    private override init() {}
    
    /**
     Create Activity-Indicator based on provided style
     
     - parameter layer : Spinner containerview layer
     - parameter size  : Size of spinner
     - parameter color : Color of spinner, default is "lightGray"
     - parameter style : Spinner style specified by user, default style is "defaultSpinner"
     */
    class func createSpinner(in layer: CALayer, size: CGSize, color: UIColor, style: LoadingActivityIndicatorType) {
        
        switch  style {
        case .circular:
            self.shared.createCircularSpinner(in: layer, size: size, color: color)
        }
    }
    
    func createCircularSpinner(in layer: CALayer, size: CGSize, color: UIColor) {
        let beginTime: Double = 0.5
        let strokeStartDuration: Double = 1.2
        let strokeEndDuration: Double = 0.7
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.byValue = Float.pi * 2
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.duration = strokeEndDuration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.duration = strokeStartDuration
        strokeStartAnimation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 0.0, 0.2, 1.0)
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = beginTime
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [rotationAnimation, strokeEndAnimation, strokeStartAnimation]
        groupAnimation.duration = strokeStartDuration + beginTime
        groupAnimation.repeatCount = .infinity
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = kCAFillModeForwards
        
        let circle = CAShapeLayer()
        let path: UIBezierPath = UIBezierPath()
        path.addArc(withCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                    radius: size.width / 2,
                    startAngle: -(.pi / 2),
                    endAngle: .pi + .pi / 2,
                    clockwise: true)
        circle.path = path.cgPath
        circle.fillColor = nil
        circle.strokeColor = color.cgColor
        circle.lineWidth = 2
        
        let frame = CGRect(
            x: (layer.bounds.width - size.width) / 2,
            y: (layer.bounds.height - size.height) / 2,
            width: size.width,
            height: size.height
        )
        
        circle.frame = frame
        circle.add(groupAnimation, forKey: "animation")
        layer.addSublayer(circle)
    }
}

//
//  ActivityIndicatorView.swift
//  LoadingAnimation
//
//  Created by David on 07/08/2018.
//  Copyright © 2018 David. All rights reserved.
//

import UIKit

public class LoadingActivityIndicator: NSObject {
    var window: UIWindow?
    var backgroundView: UIView?
    var activityIndicatorView: UIToolbar?
    var spinnerContainerView: UIView?
    
    fileprivate var spinnerColor: UIColor = UIColor.darkGray
    fileprivate var backgroundViewColor: UIColor = UIColor.init(red  : 0.0, green  : 0.0, blue  : 0.0, alpha  : 0.2)
    fileprivate var activityIndicatorStyle: LoadingActivityIndicatorType = .circular
    fileprivate var activityIndicatorTranslucency: UIBlurEffectStyle = .extraLight
    
    fileprivate static let shared: LoadingActivityIndicator = {
        let instance = LoadingActivityIndicator()
        return instance
    }()
    
    private override init() {
        super.init()
        let delegate: UIApplicationDelegate = UIApplication.shared.delegate!
        if let windowObj = delegate.window {
            window = windowObj
        } else {
            window = UIApplication.shared.keyWindow!
        }
        backgroundView = nil
        spinnerContainerView = nil
        activityIndicatorView = nil
    }

    public static func show() {
        DispatchQueue.main.async {
            self.shared.configureActivityIndicator(isUserInteractionEnabled: true)
        }
    }
    
    public static func dismiss() {
        DispatchQueue.main.async {
            self.shared.hideActivityIndicator()
        }
    }
    
    
    // MARK: - Configure Activity Indicator
    fileprivate func configureActivityIndicator(isUserInteractionEnabled userInteractionStatus: Bool) {
        
        /// Setup Activity Indicator View
        if activityIndicatorView == nil {
            activityIndicatorView = UIToolbar(frame: CGRect.zero)
            activityIndicatorView!.layer.cornerRadius = 8
            activityIndicatorView!.layer.masksToBounds = true
            activityIndicatorView!.isTranslucent = true
            registerForKeyboardNotificatoins()
        }
        
        /// Setup Spinner Container View
        if spinnerContainerView == nil {
            let spinnerViewFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
            spinnerContainerView = UIView(frame: spinnerViewFrame)
            spinnerContainerView!.backgroundColor = UIColor.clear
        }
        
        /// Setup Spinner
        if spinnerContainerView != nil {
            spinnerContainerView?.removeFromSuperview()
            spinnerContainerView = nil
            
            let spinnerViewFrame = CGRect(x: 0, y: 0, width: 37, height: 37)
            spinnerContainerView = UIView(frame: spinnerViewFrame)
            spinnerContainerView!.backgroundColor = UIColor.clear
            
            let viewLayer = spinnerContainerView!.layer
            let animationRectsize = CGSize(width: 37, height: 37)
            LoadingActivityIndicatorStyle.createSpinner(in: viewLayer, size: animationRectsize, color: spinnerColor, style: activityIndicatorStyle)
        }
        
        if spinnerContainerView?.superview == nil {
            activityIndicatorView!.addSubview(spinnerContainerView!)
        }
        
        if activityIndicatorView?.superview == nil && userInteractionStatus == false {
            backgroundView = UIView.init(frame: window!.frame)
            backgroundView!.backgroundColor = backgroundViewColor
            window!.addSubview(backgroundView!)
            backgroundView!.addSubview(activityIndicatorView!)
        } else {
            window!.addSubview(activityIndicatorView!)
        }
        
        /// Setup Activity IndicatorView Size & Position
        configureActivityIndicatorSize()
        configureActivityIndicatorPosition(notification: nil)
        showActivityIndicator()
    }
    
    
    
    // MARK: - Configure ActivityIndicator
    fileprivate func configureActivityIndicatorSize() {
        let widthHUD: CGFloat = 100
        let heightHUD: CGFloat = 100
        
        activityIndicatorView?.bounds = CGRect(x: 0, y: 0, width: widthHUD, height: heightHUD)
        
        let imageX: CGFloat = widthHUD/2
        let imageY: CGFloat = heightHUD/2
        spinnerContainerView!.center = CGPoint(x: imageX, y: imageY)
    }
    
    // MARK: - ActivityIndicator Position
    @objc fileprivate func configureActivityIndicatorPosition(notification: NSNotification?) {
        var keyboardHeight: CGFloat = 0.0
        
        if notification != nil {
            if let keyboardFrame: NSValue = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                if (notification!.name == NSNotification.Name.UIKeyboardWillShow || notification!.name == NSNotification.Name.UIKeyboardDidShow) {
                    keyboardHeight = keyboardRectangle.height
                }
            }
        } else {
            keyboardHeight = 0.0
        }
        let screen: CGRect = UIScreen.main.bounds
        let center: CGPoint = CGPoint(x: screen.size.width/2, y: (screen.size.height-keyboardHeight)/2)
        
        UIView.animate(withDuration: 0, delay: 0, options: [.allowUserInteraction], animations: {
            self.activityIndicatorView?.center = CGPoint(x: center.x, y: center.y)
        }, completion: nil)
        
        if backgroundView != nil {
            backgroundView!.frame = window!.frame
        }
    }
    
    // MARK: - Show
    fileprivate func showActivityIndicator() {
        if activityIndicatorView != nil {
            activityIndicatorView!.alpha = 0
            UIView.animate(withDuration: 0.1, animations: {
                self.activityIndicatorView?.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
                self.activityIndicatorView?.alpha = 1
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.2, animations: {() -> Void in
                    self.activityIndicatorView?.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }
    
    // MARK: - Hide
    fileprivate func hideActivityIndicator() {
        if activityIndicatorView != nil && activityIndicatorView?.alpha == 1 {
            UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .curveEaseIn], animations: {
                self.activityIndicatorView?.transform = CGAffineTransform.identity.scaledBy(x: 0.7, y: 0.7)
                self.activityIndicatorView?.alpha = 0
            }, completion: { (success) in
                self.activityIndicatorView?.alpha = 0
                self.deallocateActivityIndicator()
            })
        }
    }
    
    
    // MARK: - Deallocate ActivityIndicator
    fileprivate func deallocateActivityIndicator() {
        NotificationCenter.default.removeObserver(self)
        spinnerContainerView?.removeFromSuperview()
        spinnerContainerView = nil
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
    
    
    // MARK: - Keyboard Notifications
    fileprivate func registerForKeyboardNotificatoins() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureActivityIndicatorPosition), name: .UIApplicationDidChangeStatusBarOrientation, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureActivityIndicatorPosition), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureActivityIndicatorPosition), name: .UIKeyboardDidHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureActivityIndicatorPosition), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.configureActivityIndicatorPosition), name: .UIKeyboardDidShow, object: nil)
    }
    
    
    // MARK: - Customization Methods
    public static func spinnerColor(_ color: UIColor) {
        self.shared.spinnerColor = color
    }
    
    public static func spinnerStyle(_ spinnerStyle: LoadingActivityIndicatorType) {
        self.shared.activityIndicatorStyle = spinnerStyle
    }
}



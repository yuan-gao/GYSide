//
//  GYSide.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

var showControlelrTransitioningDelegateKey = "showControlelrTransitioningDelegateKey"
let GYSideTapNotification = "GYSideTapNotification"
let GYSidePanNotification = "GYSidePanNotification"
let kScreenWidth = UIScreen.main.bounds.width

extension UIViewController {
    
    /// 侧边栏出来
    ///
    /// - Parameters:
    ///   - configuration: 配置
    ///   - viewController: 将要展现的viewController
    public func gy_showSide(configuration:(GYSideConfig)->(), viewController:UIViewController) {
        
        let config = GYSideConfig()
        configuration(config)
        
        var delegate = objc_getAssociatedObject(self, &showControlelrTransitioningDelegateKey)
        if delegate == nil {
            delegate = GYSideTransitioningDelegate(config:config)
            objc_setAssociatedObject(viewController, &showControlelrTransitioningDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }else {
            let d = delegate as! GYSideTransitioningDelegate
            d.config = config
        }
        let d = delegate as! GYSideTransitioningDelegate
        let dismissalInteractiveTransition = GYSidePercentInteractiveTransition(showType: .hidden, viewController:viewController, config: config)
        d.dismissalInteractiveTransition = dismissalInteractiveTransition
        viewController.transitioningDelegate = delegate as? UIViewControllerTransitioningDelegate

        DispatchQueue.main.async { //防止present延迟
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    
    /// 让侧边栏支持手势拖拽出来
    ///
    /// - Parameter completeShowGesture: 侧边栏展示的方向
    public func gy_registGestureShowSide(completeShowGesture:@escaping (GYSideDirection)->()) {
        let  delegate = GYSideTransitioningDelegate(config: nil)
        let presentationInteractiveTransition = GYSidePercentInteractiveTransition(showType: .show, viewController: nil, config: nil)
        presentationInteractiveTransition.addPanGesture(fromViewController: self)
        presentationInteractiveTransition.completeShowGesture = completeShowGesture
        delegate.presentationInteractiveTransition = presentationInteractiveTransition
        
        self.transitioningDelegate = delegate
        objc_setAssociatedObject(self, &showControlelrTransitioningDelegateKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    public func gy_sidePushViewController(viewController: UIViewController) {
        let rootVC: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        var nav: UINavigationController?
        if rootVC.isKind(of: UITabBarController.classForCoder()) {
            let tabBar: UITabBarController = rootVC as! UITabBarController
            nav = tabBar.selectedViewController as? UINavigationController
        }else if rootVC.isKind(of: UINavigationController.classForCoder()) {
            nav = rootVC as? UINavigationController
        }else {
            fatalError("没有UINavigationController")
        }
        self.dismiss(animated: true, completion: nil)
        nav?.pushViewController(viewController, animated: false)
    }
    
    
    /// 侧边栏调用present
    ///
    /// - Parameter viewController
    public func gy_sidePresentViewController(viewController: UIViewController) {
        let rootVC: UIViewController = (UIApplication.shared.keyWindow?.rootViewController)!
        if ((rootVC.presentedViewController) != nil) {
            rootVC.presentedViewController?.dismiss(animated: true, completion: {
                DispatchQueue.main.async {                
                    rootVC.present(viewController, animated: true, completion: nil)
                }
            })
        }
    }
    
}

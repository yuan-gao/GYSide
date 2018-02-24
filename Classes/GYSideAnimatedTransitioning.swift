//
//  GYSideAnimatedTransitioning.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

enum GYSideShowType:Int {
    case show,hidden
}

class GYSideAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning {
    
    var type:GYSideShowType!
    var config:GYSideConfig!
    
    init(showType: GYSideShowType,config: GYSideConfig) {
        super.init()
        type = showType
        self.config = config
    }
    
    // 执行的动画时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.timeInterval;
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .show?:
            animateTransitionShowType(transitionContext: transitionContext)
            break
        case .hidden?:
            animateTransitionHiddenType(transitionContext: transitionContext)
            break
        default:
            break
        }
    }
    
    // show
    func animateTransitionShowType(transitionContext: UIViewControllerContextTransitioning) {
        let fromController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toController: UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let containerView = transitionContext.containerView
        let width:CGFloat = (UIApplication.shared.keyWindow?.bounds.size.width)! * self.config.sideRelative
        let x:CGFloat! = config.direction == .left ? 0.0 : ((UIApplication.shared.keyWindow?.bounds.size.width)! - width)
        toController.view.frame = CGRect.init(x: x, y: 0, width: width, height: containerView.frame.height)
        toController.view.clipsToBounds = true
        // fromController UINavigationController
        // toController SnapKitViewController
        containerView.addSubview(toController.view)
        containerView.addSubview(fromController.view)
        
        var mask:GYSideMaskView?
        for view in toController.view.subviews {
            if view.isKind(of: GYSideMaskView.classForCoder()){
                mask = view as? GYSideMaskView
                break
            }
        }
        if mask == nil {
            mask = GYSideMaskView()
            fromController.view.addSubview(mask!)
        }
        mask?.frame = fromController.view.bounds
        mask?.alpha = 0.0
        mask?.isUserInteractionEnabled = false
        
        let flag: CGFloat! = config.direction == .left ? -1.0 : 1.0
        
        var fromTransform: CGAffineTransform = CGAffineTransform.init(translationX: -flag * width, y: 0)
        let toTransform: CGAffineTransform = CGAffineTransform.init(translationX: flag * width, y: 0)
        
        if self.config.animationType == .translationMask {
            fromTransform = CGAffineTransform.init(translationX: 0, y: 0)
            containerView.bringSubview(toFront: toController.view)
        }else if self.config.animationType == .zoom {
            let t1: CGAffineTransform = CGAffineTransform.init(translationX: -flag * width * config.zoomOffsetRelative, y: 0)
            let t2: CGAffineTransform = CGAffineTransform.init(scaleX: config.zoomRelative, y: config.zoomRelative)
            fromTransform = t1.concatenating(t2)
        }
        if self.config.animationType != .zoom {
            toController.view.transform = toTransform
            toController.view.frame = CGRect.init(x: toTransform.tx+x, y: 0, width: width, height: containerView.frame.height)
        }else {
            toController.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
            toController.view.frame = CGRect.init(x: 0, y: 0, width: width, height: containerView.frame.height)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            mask?.alpha = self.config.maskAlpha
            toController.view.transform = .identity
            fromController.view.transform = fromTransform
        }) { (finished) in
            if !transitionContext.transitionWasCancelled {
                mask?.isUserInteractionEnabled = true
                transitionContext.completeTransition(true)
                containerView.addSubview(fromController.view)
                if self.config.animationType == .translationMask {
                    containerView.bringSubview(toFront: toController.view)
                }
            }else {
                mask?.destroy()
                toController.view.transform = toTransform;
                fromController.view.frame = containerView.frame;
                transitionContext.completeTransition(false)
            }
        }
    }
    

    // hidde
    func animateTransitionHiddenType(transitionContext: UIViewControllerContextTransitioning) {
        let fromController:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toController:UIViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView = transitionContext.containerView
        let width:CGFloat = (UIApplication.shared.keyWindow?.bounds.size.width)! * self.config.sideRelative
        let x:CGFloat! = config.direction == .left ? 0.0 : ((UIApplication.shared.keyWindow?.bounds.size.width)! - width)
        
        fromController.view.frame = CGRect.init(x: x, y: 0, width: width, height: containerView.frame.height)
    
        var mask:GYSideMaskView?
        for view in toController.view.subviews {
            if view.isKind(of: GYSideMaskView.classForCoder()){
                mask = view as? GYSideMaskView
                break
            }
        }
        
        let flag: CGFloat! = config.direction == GYSideDirection.left ? -1.0 : 1.0
        var fromTransform:CGAffineTransform = CGAffineTransform.init(translationX: flag * width, y: 0)
        
        if self.config.animationType == .translationMask {
            fromTransform = CGAffineTransform.init(translationX: flag * width, y: 0)
        }else if self.config.animationType == .zoom {
            fromTransform = CGAffineTransform.init(translationX: 0, y: 0)
            containerView.bringSubview(toFront: toController.view)
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            mask?.alpha = 0.001
            fromController.view.transform = fromTransform
            toController.view.transform = .identity
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if !transitionContext.transitionWasCancelled {
                mask?.destroy()
            }else {
                if self.config.animationType != .zoom {
                    containerView.bringSubview(toFront: fromController.view)
                }
            }
        }
    }
    
    deinit {
//        print( NSStringFromClass(self.classForCoder) + " 销毁了---->4")
    }
}


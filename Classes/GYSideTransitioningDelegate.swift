//
//  GYSideTransitioningDelegate.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

class GYSideTransitioningDelegate: NSObject,UIViewControllerTransitioningDelegate {
    
    var presentationInteractiveTransition: GYSidePercentInteractiveTransition?
    var dismissalInteractiveTransition: GYSidePercentInteractiveTransition!
    var config: GYSideConfig!
    
    init(config:GYSideConfig?) {
        self.config = config
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GYSideAnimatedTransitioning(showType: .show, config: config)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return GYSideAnimatedTransitioning(showType: .hidden, config: config)
    }
    
    // present交互的百分比
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if presentationInteractiveTransition == nil {
            return nil
        }else {
            return (presentationInteractiveTransition?.isInteractive)! ? presentationInteractiveTransition : nil
        }
    }
    
    // dismiss交互的百分比
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return dismissalInteractiveTransition.isInteractive ? dismissalInteractiveTransition : nil
    }
    deinit {
//        print( NSStringFromClass(self.classForCoder) + " 销毁了---->3")
    }
    
}


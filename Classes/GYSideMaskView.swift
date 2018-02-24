//
//  GYSideMaskView.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

final class GYSideMaskView: UIVisualEffectView {

    init() {
        super.init(effect: UIBlurEffect.init(style: .dark))
        //初始准备代码
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapAction(_ :)))
        self.addGestureRecognizer(tap)
        
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panAction(_ :)))
        self.addGestureRecognizer(pan)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func tapAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GYSideTapNotification), object: nil)
    }
    
    @objc private func panAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GYSidePanNotification), object: sender)
    }
    
    func destroy() {
        self.removeFromSuperview()
    }
    
    deinit {
//        print( NSStringFromClass(self.classForCoder) + " 销毁了---->2")
    }
}


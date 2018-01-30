//
//  GYSideMaskView.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

var single: GYSideMaskView?
final class GYSideMaskView: UIView {
    
    static let shared: GYSideMaskView = {
        single = GYSideMaskView()
        //初始准备代码
        single?.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: single, action: #selector(tapAction(_ :)))
        single?.addGestureRecognizer(tap)

        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: single, action: #selector(panAction(_ :)))
        single?.addGestureRecognizer(pan)

        return single!
    }();
    
    @objc private func tapAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GYSideTapNotification), object: nil)
    }
    
    @objc private func panAction(_ sender:UITapGestureRecognizer) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:GYSidePanNotification), object: sender)
    }
    
    func destroy() {
        single?.removeFromSuperview()
        single = nil
    }
    
    deinit {
        print( NSStringFromClass(self.classForCoder) + " 销毁了---->2")
    }
}


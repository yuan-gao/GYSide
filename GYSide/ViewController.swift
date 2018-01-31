//
//  ViewController.swift
//  GYSide
//
//  Created by gaoyuan on 2018/1/29.
//  Copyright © 2018年 gaoyuan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var titleArray = ["左出平移","左出遮盖","左出缩放","右出平移","右出遮盖","右出缩放"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSubviews()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    
    func configSubviews() {
        
        self.view.backgroundColor = UIColor.white
        let imgView = UIImageView.init(frame: self.view.bounds)
        imgView.image = UIImage.init(named: "4.jpeg")
        self.view.addSubview(imgView)
        
        let tableView:UITableView = UITableView.init(frame: self.view.bounds, style:UITableViewStyle(rawValue: 0)!)
        tableView.backgroundView = imgView;
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "id")
        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(tableView)
        
//        let vc = LeftViewController.init()
//        self.gy_registGestureShowSide { (direction) in
//            if direction == .left {
//                self.gy_showSide(configuration: { (config) in
//                    config.animationType = .zoom
//                }, viewController: vc)
//            }else {
//                self.gy_showSide(configuration: { (config) in
//                    config.direction = .right
//                }, viewController: vc)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "id")!
        cell.textLabel?.text = titleArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 { //左出平移
            let vc = LeftViewController.init()
            gy_showSide(configuration: { (config) in
                
            }, viewController: vc)
        }else if indexPath.row == 1 { //左出遮罩
            let vc = LeftViewController.init()
            gy_showSide(configuration: { (config) in
                config.animationType = .translationMask
                config.sideRelative = 0.6
                //                config.timeInterval = 3;
            }, viewController: vc)
        }else if indexPath.row == 2 { //左出缩放
            let vc = LeftViewController.init()
            gy_showSide(configuration: { (config) in
                config.direction = .left
                config.animationType = .zoom
                config.sideRelative = -1.0;
            }, viewController: vc)
        }else if indexPath.row == 3 { //右出平移
            let vc = RightViewController.init()
            gy_showSide(configuration: { (config) in
                config.direction = .right
            }, viewController: vc)
        }else if indexPath.row == 4 { //右出遮罩
            let vc = RightViewController.init()
            gy_showSide(configuration: { (config) in
                config.direction = .right
                config.animationType = .translationMask
            }, viewController: vc)
        }else if indexPath.row == 5 { //右出缩放
            let vc = RightViewController.init()
            gy_showSide(configuration: { (config) in
                config.direction = .right
                config.animationType = .zoom
            }, viewController: vc)
        }
    }
    
    deinit {
        print( NSStringFromClass(self.classForCoder) + " 销毁了")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

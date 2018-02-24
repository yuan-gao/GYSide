# GYSide安装

## CocoaPods
- 在 Podfile 中添加 `pod 'GYSide'`
-  执行 `pod setup` 更新本地pod库
- 执行 `pod install` 或 `pod update` 安装

## 效果

![](http://upload-images.jianshu.io/upload_images/959455-3acdcba52c033df9.gif?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 使用

- 显示侧边栏

```
let vc = LeftViewController.init()
gy_showSide(configuration: { (config) in
    config.animationType = .zoom // 侧边来出来的动画方式
    config.timeInterval = 0.3 // 执行动画的时长 默认0.3
    config.direction = .left // 侧边来出来的的方向 默认从左边出来
    config.maskAlpha = 0.5 // 遮罩视图的透明度 默认0.5
    config.sideRelative = 0.7 // 侧边栏相对屏幕宽度比例 默认0.7
    config.zoomOffsetRelative = 0.5 // 缩放模式时 缩放控制器的view偏移相对屏幕宽度比例 默认0.5
    config.zoomRelative = 0.7 // 缩放模式时缩放的比例 默认0.7
}, viewController: vc)
```

- 从侧边栏push控制器

```
 self.gy_sidePushViewController(viewController: UIViewController())
```

- 从侧边栏present控制器

```
 self.gy_sidePresentViewController(viewController: UIViewController())
```
//
//  AppDelegate.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
import Alamofire
import IQKeyboardManagerSwift

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    lazy var reachability: NetworkReachabilityManager? = {
       return NetworkReachabilityManager(host: "https://app.u17.com")
    }()
    //手机屏幕旋转方向
    var orientation:UIInterfaceOrientationMask = .portrait
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UMCommonLogSwift.setUpUMCommonLogManager()
        UMCommonSwift.setLogEnabled(bFlag: true)
        UMCommonSwift.initWithAppkey(appKey: "5e169749570df300b400030e", channel: "App Store")
        UMAnalyticsSwift.setScenarioType(eSType: eScenarioType.E_UM_GAME)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //配着
        setupBaseConfig()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController = CTTabBarController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func setupBaseConfig() {
     // 1.偏好设置: 性别缓存
       let defaults = UserDefaults.standard
       if defaults.value(forKey: String.sexTypeKey) == nil {
           defaults.set(1, forKey: String.sexTypeKey)
           defaults.synchronize()
       }
    
        reachability?.listener = {
            status in
            switch status {
            case .reachable(.wwan):
                UNoticeBar(config: UNoticeBarConfig(title: "检测到您正在使用移动数据")).show(duration: 2)
            default:
                break
            }
        }
        reachability?.startListening()
    }
    // 3.支持屏幕旋转
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientation
    }
    
}

extension UIApplication {
    // 4. 强制旋转屏幕
    class func changeOrientationTo(landscapeRight: Bool) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        if landscapeRight == true {
            delegate.orientation = .landscapeRight
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        } else {
            delegate.orientation = .portrait
            UIApplication.shared.supportedInterfaceOrientations(for: delegate.window)
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
}

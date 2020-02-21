//
//  CTTabBarController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        
        setupLayout()
    }
    func setupLayout() {
        //首页
        let homePageVC = CTHomeController(titles: ["推荐","排行"], vcs: [CTHomeCommentController(),CTHomeRankController()], pageStyle: .navgationBarSegment)
        addChildController(homePageVC,
        title: "首页",
        image: UIImage(named: "tab_home"),
        selectedImage: UIImage(named: "tab_home_s"))
        
        // 2.分类
         let classVC = CTCateController()
         addChildController(classVC,
                                title: "分类",
                                image: UIImage(named: "tab_class"),
                                selectedImage: UIImage(named: "tab_class_s"))
    }
    func addChildController(_ childController: UIViewController, title:String?, image:UIImage? ,selectedImage:UIImage?) {
        
        childController.title = title
        childController.tabBarItem = UITabBarItem(title: nil,
                                                  image: image?.withRenderingMode(.alwaysOriginal),
                                                  selectedImage: selectedImage?.withRenderingMode(.alwaysOriginal))
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            childController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(CTNaviController(rootViewController: childController))
    }
}
extension CTTabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let select = selectedViewController else { return .lightContent }
        return select.preferredStatusBarStyle
    }
}

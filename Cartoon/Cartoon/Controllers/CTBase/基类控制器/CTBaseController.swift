//
//  CTBaseController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Reusable
import Kingfisher
class CTBaseController: UIViewController {
    override func viewDidLoad() {
           super.viewDidLoad()

           view.backgroundColor = UIColor.white
           
           if #available(iOS 11.0, *) {
               UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
           } else {
               automaticallyAdjustsScrollViewInsets = false
           }
           setupLayout()

       }
       
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           configNavigationBar()
       }
       
       func setupLayout() {}

       func configNavigationBar() {
           guard let navi = navigationController else { return }
           if navi.visibleViewController == self {
               navi.barStyle(.white)
               navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.gray,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
               navi.navigationBar.shadowImage = UIImage() 
               navi.disablePopGesture = false
               navi.setNavigationBarHidden(false, animated: true)
               if navi.viewControllers.count > 1 {
                   navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_black"),
                                                                      target: self,
                                                                      action: #selector(pressBack))
            };
           }
       }
       
       @objc func pressBack() {
           navigationController?.popViewController(animated: true)
       }
}
extension CTBaseController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .`default`
    }
}

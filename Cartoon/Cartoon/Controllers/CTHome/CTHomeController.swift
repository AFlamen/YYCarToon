//
//  CTHomeController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTHomeController: CTPageController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search"),
                                                            target: self,
                                                            action: #selector(searchButtonClick))
    }
    
    @objc private func searchButtonClick() {
        navigationController?.pushViewController(CTSearchController(), animated: true)
    }

}

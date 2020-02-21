//
//  CTBaseCollectionReusableView.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
import Reusable

class CTBaseCollectionReusableView: UICollectionReusableView,Reusable {
override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

open func setupLayout() {}
}

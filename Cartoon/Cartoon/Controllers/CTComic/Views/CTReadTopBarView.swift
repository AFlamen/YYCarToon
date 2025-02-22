//
//  CTReadTopBarView.swift
//  Cartoon
//
//  Created by yzl on 2020/1/9.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTReadTopBarView: UIView {

    lazy var backButton: UIButton = {
           let backButton = UIButton(type: .custom)
           backButton.setImage(UIImage(named: "nav_back_black"), for: .normal)
           return backButton
       }()
       
       lazy var titleLabel: UILabel = {
           let titleLabel = UILabel()
           titleLabel.textAlignment = .center
           titleLabel.textColor = UIColor.black
           titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
           return titleLabel
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupUI()
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func setupUI() {
           
           addSubview(backButton)
           
           backButton.snp.makeConstraints { make in
               make.width.height.equalTo(40)
               make.left.centerY.equalToSuperview()
           }
           
           addSubview(titleLabel)
           titleLabel.snp.makeConstraints { make in
               make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
           }
       }

}

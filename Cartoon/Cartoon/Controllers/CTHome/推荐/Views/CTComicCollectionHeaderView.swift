//
//  CTComicCollectionHeaderView.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
// 回调 相当于 OC中的Block (闭包)
typealias CTComicCollectionHeaderMoreActionBlock = ()->Void

// 代理
protocol CTComicCollecHeaderViewDelegate: class {
    func comicCollectionHeaderView(_ comicCHead: CTComicCollectionHeaderView, moreAction button: UIButton)
}
class CTComicCollectionHeaderView: CTBaseCollectionReusableView {
        // 代理声明 弱引用
        weak var delegate: CTComicCollecHeaderViewDelegate?
        // 回调声明 相当于 OC中的Block
        private var moreActionClosure: CTComicCollectionHeaderMoreActionBlock?
        
        lazy var iconView: UIImageView = {
            return UIImageView()
        }()
        
        lazy var titleLabel: UILabel = {
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = .black
            return titleLabel
        }()
        
        lazy var moreButton: UIButton = {
            let mn = UIButton(type: .system)
            mn.setTitle("•••", for: .normal)
            mn.setTitleColor(UIColor.lightGray, for: .normal)
            mn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            mn.addTarget(self, action: #selector(moreActionClick), for: .touchUpInside)
            return mn
        }()
        
        @objc func moreActionClick(button: UIButton) {
            delegate?.comicCollectionHeaderView(self, moreAction: button)
            
            guard let closure = moreActionClosure else { return }
            closure()
        }
        
        func moreActionClosure(_ closure: CTComicCollectionHeaderMoreActionBlock?) {
            moreActionClosure = closure
        }
        
        // 继承父类方法 布局
        override func setupLayout() {
            
            addSubview(iconView)
            iconView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(5)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(40)
            }
            
            addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.left.equalTo(iconView.snp.right).offset(5)
                make.centerY.height.equalTo(iconView)
                make.width.equalTo(200)
            }
            
            addSubview(moreButton)
            moreButton.snp.makeConstraints { make in
                make.top.right.bottom.equalToSuperview()
                make.width.equalTo(40)
            }
        }
}

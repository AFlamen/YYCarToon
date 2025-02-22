//
//  CTBoardCollectionViewCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTBoardCollectionViewCell: CTBaseCollectionViewCell {
    // 布局
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        return iconView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    // 继承父类方法 布局
    override func setupLayout() {
        clipsToBounds = true
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom)
            make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            make.height.equalTo(20)
        }
    }
    
    var model: CTComicModel? {
        didSet {
            guard let model = model else { return }
            iconView.kf.setImage(urlString: model.cover)
            titleLabel.text = model.name
        }
    }
}

//
//  CTOtherWorksCollectionViewCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/9.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTOtherWorksCollectionViewCell: CTBaseCollectionViewCell {
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
          return titleLabel
      }()
      
      private lazy var descLabel: UILabel = {
          let descLabel = UILabel()
          descLabel.textColor = UIColor.gray
          descLabel.font = UIFont.systemFont(ofSize: 12)
          return descLabel
      }()
      
      override func setupLayout() {
          
          contentView.addSubview(descLabel)
          descLabel.snp.makeConstraints { make in
              make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
              make.height.equalTo(20)
          }
          
          contentView.addSubview(titleLabel)
          titleLabel.snp.makeConstraints { make in
              make.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
              make.height.equalTo(25)
              make.bottom.equalTo(descLabel.snp.top)
          }
          
          contentView.addSubview(iconView)
          iconView.snp.makeConstraints { make in
              make.top.left.right.equalToSuperview()
              make.bottom.equalTo(titleLabel.snp.top)
          }
      }
      
      
      var model: CTOtherWorkModel? {
          didSet {
              guard let model = model else { return }
              iconView.kf.setImage(urlString: model.coverUrl,
                                   placeholder: (bounds.width > bounds.height) ? UIImage(named: "normal_placeholder_h") : UIImage(named: "normal_placeholder_v"))
              titleLabel.text = model.name
              descLabel.text = "更新至\(model.passChapterNum)话"
          }
      }
      
}

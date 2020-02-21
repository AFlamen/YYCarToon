//
//  CTUpdateTVCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTUpdateTVCell: CTBaseTableViewCell {

   private lazy var coverView: UIImageView = {
           let coverView = UIImageView()
           coverView.contentMode = .scaleAspectFill
           coverView.layer.cornerRadius = 5
           coverView.layer.masksToBounds = true
           return coverView
       }()
       
       private lazy var tipLabel: UILabel = {
           let tipLabel = UILabel()
           tipLabel.backgroundColor = UIColor.black.withAlphaComponent(0.4)
           tipLabel.textColor = UIColor.white
           tipLabel.font = UIFont.systemFont(ofSize: 9)
           return tipLabel
       }()
       
       override func setupUI() {
           
           contentView.addSubview(coverView)
           coverView.snp.makeConstraints { make in
               make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
           }
           
           coverView.addSubview(tipLabel)
           tipLabel.snp.makeConstraints { make in
               make.left.bottom.right.equalToSuperview()
               make.height.equalTo(20)
           }
           
           let line = UIView().then{
               $0.backgroundColor = UIColor.background
           }
           contentView.addSubview(line)
           line.snp.makeConstraints { make in
               make.left.right.bottom.equalToSuperview()
               make.height.equalTo(10)
           }
       }
       
       var model: CTComicModel? {
           didSet {
               guard let model = model else { return }
               coverView.kf.setImage(urlString: model.cover)
               tipLabel.text = "    \(model.description ?? "")"
           }
       }

}

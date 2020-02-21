//
//  CTChapterCollectionViewCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTChapterCollectionViewCell: CTBaseCollectionViewCell {
    lazy var nameLabel: UILabel = {
           let nl = UILabel()
           nl.font = UIFont.systemFont(ofSize: 16)
           return nl
       }()
       
       override func setupLayout() {
           contentView.backgroundColor = UIColor.white
           layer.cornerRadius = 5
           layer.borderWidth = 1
           layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
           layer.masksToBounds = true
           
           contentView.addSubview(nameLabel)
           nameLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)) }
       }
       
       var chapterStatic: CTChapterStaticModel? {
           didSet {
               guard let chapterStatic = chapterStatic else { return }
               nameLabel.text = chapterStatic.name
           }
       }
}

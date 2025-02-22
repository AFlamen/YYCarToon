//
//  CTDescriptionTCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTDescriptionTCell: CTBaseTableViewCell {
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.textColor = UIColor.gray
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    override func setupUI() {
        let titileLabel = UILabel().then{
            $0.text = "作品介绍"
        }
        contentView.addSubview(titileLabel)
        titileLabel.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            make.height.equalTo(20)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints{ make in
            make.top.equalTo(titileLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    var model: CTDetailStaticModel? {
        didSet{
            guard let model = model else { return }
            textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        }
    }
    // 计算作品介绍高度
    class func height(for detailStatic: CTDetailStaticModel?) -> CGFloat {
        var height: CGFloat = 50.0
        guard let model = detailStatic else { return height }
        let textView = UITextView().then{
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        height += textView.sizeThatFits(CGSize(width: screenWidth - 30, height: CGFloat.infinity)).height
        return height
    }
}

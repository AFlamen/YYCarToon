//
//  CTSearchHeadView.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

typealias CTSearchTHeadMoreActionClosure = ()->Void

protocol CTSearchHeadViewDelegate: class {
    func searchHeadView(_ searchTHead: CTSearchHeadView, moreAction button: UIButton)
}
class CTSearchHeadView: CTBaseTableViewHeaderFooterView {

  weak var delegate: CTSearchHeadViewDelegate?
    
    private var moreActionClosure: CTSearchTHeadMoreActionClosure?
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.gray
        return titleLabel
    }()
    
    lazy var moreButton: UIButton = {
        let moreButton = UIButton(type: .custom)
        moreButton.setTitleColor(UIColor.lightGray, for: .normal)
        moreButton.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        return moreButton
    }()
    
    @objc private func moreAction(button: UIButton) {
        delegate?.searchHeadView(self, moreAction: button)
        
        guard let closure = moreActionClosure else { return }
        closure()
    }
    
    func moreActionClosure(_ closure: @escaping CTSearchTHeadMoreActionClosure) {
        moreActionClosure = closure
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(200)
        }
        
        contentView.addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.top.right.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        let line = UIView().then { $0.backgroundColor = UIColor.background }
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}

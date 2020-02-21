//
//  CTReadCollectionViewCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/9.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
import Kingfisher

class CTReadCollectionViewCell: CTBaseCollectionViewCell {
   lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var placeholder: UIImageView = {
        let placeholder = UIImageView(image: UIImage(named: "yaofan"))
        placeholder.contentMode = .center
        return placeholder
    }()
    
    override func setupLayout() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
    var model: CTImageModel? {
        didSet {
            guard let model = model else { return }
            imageView.image = nil
            imageView.kf.setImage(urlString: model.location, placeholder: placeholder)
        }
    }
}
extension UIImageView: Placeholder {}

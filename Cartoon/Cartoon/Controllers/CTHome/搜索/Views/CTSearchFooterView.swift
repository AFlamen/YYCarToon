//
//  CTSearchFooterView.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

typealias CTSearchTFootDidSelectIndexClosure = (_ index: Int, _ model: CTSearchItemModel) -> Void

protocol CTSearchFooterViewDelegate: class {
    func searchFooterView(_ searchTFoot: CTSearchFooterView, didSelectItemAt index: Int, _ model: CTSearchItemModel)
}

class CTSearchCollectionViewCell: CTBaseCollectionViewCell {

   lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.darkGray
        return titleLabel
    }()
    override func setupLayout() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.background.cgColor
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)) }
    }

}
class CTSearchFooterView: CTBaseTableViewHeaderFooterView {
    
    weak var delegate: CTSearchFooterViewDelegate?
    
    private var didSelectIndexClosure: CTSearchTFootDidSelectIndexClosure?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UCollectionViewAlignedLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.horizontalAlignment = .left
        layout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cellType: CTSearchCollectionViewCell.self)
        return collectionView
    }()
    
    var data: [CTSearchItemModel] = [] {
        didSet {
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func setupLayout() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in make.edges.equalToSuperview() }
    }
    
}

extension CTSearchFooterView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTSearchCollectionViewCell.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.titleLabel.text = data.count > indexPath.row ? data[indexPath.row].name:""
//        cell.backgroundColor = UIColor.random
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchFooterView(self, didSelectItemAt: indexPath.row, data[indexPath.row] )
        if data.count > indexPath.row {
            guard let closure = didSelectIndexClosure else { return }
                 closure(indexPath.row, data[indexPath.row])
        }
    }
    
    func didSelectIndexClosure(_ closure: @escaping CTSearchTFootDidSelectIndexClosure) {
        didSelectIndexClosure = closure
    }
}

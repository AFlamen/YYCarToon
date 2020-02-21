//
//  CTGuessLikeTVCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
typealias CTGuessLikeTVCellDidSelectClosure = (_ comic: CTComicModel) -> Void
class CTGuessLikeTVCell: CTBaseTableViewCell {

  private var didSelectClosure: CTGuessLikeTVCellDidSelectClosure?
       
       
       private lazy var collectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
           layout.scrollDirection = .horizontal
           let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
           collectionView.backgroundColor = self.contentView.backgroundColor
           collectionView.delegate = self
           collectionView.dataSource = self
           collectionView.isScrollEnabled = false
           collectionView.register(cellType: CTComicCollectionViewCell.self)
           return collectionView
       }()
       
       override func setupUI(){
           let titileLabel = UILabel().then{
               $0.text = "猜你喜欢"
           }
           contentView.addSubview(titileLabel)
           titileLabel.snp.makeConstraints{ make in
               make.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
               make.height.equalTo(20)
           }
           
           contentView.addSubview(collectionView)
           collectionView.snp.makeConstraints { make in
               make.top.equalTo(titileLabel.snp.bottom).offset(5)
               make.left.bottom.right.equalToSuperview()
           }
       }
       
       var model: CTGuessLikeModel? {
           didSet {
               self.collectionView.reloadData()
               self.collectionView.collectionViewLayout.invalidateLayout()
           }
       }

}
extension CTGuessLikeTVCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 50) / 4)
        let height = collectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
        cell.cellStyle = .withTitle
        cell.model = model?.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let comic = model?.comics?[indexPath.row],
            let didSelectClosure = didSelectClosure else { return }
        didSelectClosure(comic)
    }
    
    func didSelectClosure(_ closure: CTGuessLikeTVCellDidSelectClosure?) {
        didSelectClosure = closure
    }
}

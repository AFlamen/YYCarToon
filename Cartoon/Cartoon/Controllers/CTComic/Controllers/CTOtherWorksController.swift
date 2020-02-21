//
//  CTOtherWorksController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/9.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTOtherWorksController: CTBaseController {

  var otherWorks: [CTOtherWorkModel]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: CTOtherWorksCollectionViewCell.self)
        return collectionView
    }()
    
    convenience init(otherWorks: [CTOtherWorkModel]?) {
        self.init()
        self.otherWorks = otherWorks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.usnp.edges)
        }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationItem.title = "其他作品"
    }

}
extension CTOtherWorksController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherWorks?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 40) / 3)
        return CGSize(width: width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTOtherWorksCollectionViewCell.self)
        cell.model = otherWorks?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let model = otherWorks?[indexPath.row] else { return }
        let vc = CTComicController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
}

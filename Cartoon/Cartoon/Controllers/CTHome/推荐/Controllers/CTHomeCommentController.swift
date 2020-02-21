//
//  CTHomeCommentController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit
import LLCycleScrollView

class CTHomeCommentController: CTBaseController {
    //性别暂时无用
    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    private var galleryItems = [CTGalleryItemModel]()
    private var textItems = [CTTextItemModel]()
    private var comicLists = [CTComicListModel]()
    
    private lazy var bannerView: LLCycleScrollView = {
        let cycleScrollView = LLCycleScrollView()
        cycleScrollView.backgroundColor = UIColor.background
        cycleScrollView.autoScrollTimeInterval = 6
        cycleScrollView.placeHolderImage = UIImage(named: "normal_placeholder")
        cycleScrollView.coverImage = UIImage()
        cycleScrollView.pageControlPosition = .center
        cycleScrollView.pageControlBottom = 20
        cycleScrollView.titleBackgroundColor = UIColor.clear
        cycleScrollView.lldidSelectItemAtIndex = didSelectBanner(index:)
        return cycleScrollView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        collectionView.backgroundColor = UIColor.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        // 注册cell
        collectionView.register(cellType: CTComicCollectionViewCell.self)
        collectionView.register(cellType: CTBoardCollectionViewCell.self)
        // 注册头部 尾部
        collectionView.register(supplementaryViewType: CTComicCollectionHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: CTComicCollectionFooterView.self, ofKind: UICollectionView.elementKindSectionFooter)
        // 刷新控件
        collectionView.uHead = URefreshHeader { [weak self] in self?.setupLoadData(false) }
        collectionView.uFoot = URefreshDiscoverFooter()
        collectionView.uempty = UEmptyView(verticalOffset: -(collectionView.contentInset.top)) { self.setupLoadData(false) }
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadData(false)
    }
    
    private func didSelectBanner(index: NSInteger) {
        let item = galleryItems[index]
        if item.linkType == 2 {
            guard let url = item.ext?.compactMap({
                return $0.key == "url" ? $0.val : nil
            }).joined() else {
                return
            }
            let vc = CTWebController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let comicIdString = item.ext?.compactMap({
                return $0.key == "comicId" ? $0.val : nil
            }).joined(),
                
                let comicId = Int(comicIdString) else { return }
            let vc = CTComicController(comicid: comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    // 继承了父类
    override func setupLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }

        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{ make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(collectionView.contentInset.top)
        }
    }
    private func setupLoadData(_ changeSex: Bool) {
          if changeSex {
              sexType = 3 - sexType
              UserDefaults.standard.set(sexType, forKey: String.sexTypeKey)
              UserDefaults.standard.synchronize()
              NotificationCenter.default.post(name: .USexTypeDidChange, object: nil)
          }

          ApiLoadingProvider.request(CTApi.boutiqueList(sexType: sexType), model: CTBoutiqueListModel.self) { [weak self] (returnData) in
              self?.galleryItems = returnData?.galleryItems ?? []
              self?.textItems = returnData?.textItems ?? []
              self?.comicLists = returnData?.comicLists ?? []
            
//              self?.sexTypeButton.setImage(UIImage(named: self?.sexType == 1 ? "gender_male" : "gender_female"),
//                                           for: .normal)

              self?.collectionView.uHead.endRefreshing()
              self?.collectionView.uempty?.allowShow = true

              self?.collectionView.reloadData()
              self?.collectionView.collectionViewLayout.invalidateLayout()
              self?.bannerView.imagePaths = self?.galleryItems.filter { $0.cover != nil }.map { $0.cover! } ?? []
          }
      }
}
extension CTHomeCommentController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.prefix(4).count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: CTComicCollectionHeaderView.self)
            let comicList = comicLists[indexPath.section]
            headerView.iconView.kf.setImage(urlString: comicList.newTitleIconUrl)
            headerView.titleLabel.text = comicList.itemTitle
            headerView.moreActionClosure { [weak self] in
                if comicList.comicType == .thematic {
                    let vc = CTPageController(titles: ["漫画",
                                                          "次元"],
                                                 vcs: [CTSpecialController(argCon: 2),
                                                       CTSpecialController(argCon: 4)],
                                                 pageStyle: .navgationBarSegment)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                else if comicList.comicType == .animation {
                    let vc = CTWebController(url: "http://m.u17.com/wap/cartoon/list")
                    vc.title = "动画"
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else if comicList.comicType == .update {
                    let vc = CTUpdateListController(argCon: comicList.argCon,
                                                       argName: comicList.argName,
                                                       argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = CTComicListController(argCon: comicList.argCon,
                                                      argName: comicList.argName,
                                                      argValue: comicList.argValue)
                    vc.title = comicList.itemTitle
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            return headerView
        } else {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: CTComicCollectionFooterView.self)
            return footerView
        }
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTBoardCollectionViewCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: CTComicCollectionViewCell.self)
            if comicList.comicType == .thematic {
                cell.cellStyle = .none
            } else {
                cell.cellStyle = .withTitieAndDesc
            }
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = comicLists[indexPath.section]
        guard let item = comicList.comics?[indexPath.row] else { return }
        
        if comicList.comicType == .billboard {
            let vc = CTComicListController(argName: item.argName,
                                              argValue: item.argValue)
            vc.title = item.name
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if item.linkType == 2 {
                guard let url = item.ext?.compactMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
                let vc = CTWebController(url: url)
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc = CTComicController(comicid: item.comicId)
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints{ $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top))) }
        }
    }

//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        if scrollView == collectionView {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.sexTypeButton.transform = CGAffineTransform(translationX: 50, y: 0)
//            })
//        }
//    }

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView == collectionView {
//            UIView.animate(withDuration: 0.5, animations: {
//                self.sexTypeButton.transform = CGAffineTransform.identity
//            })
//        }
//    }
}

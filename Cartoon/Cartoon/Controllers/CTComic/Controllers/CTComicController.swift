//
//  CTComicController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

protocol CTComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}
class CTComicController: CTBaseController {
  
    private var comicid: Int = 0
      
      private lazy var mainScrollView: UIScrollView = {
          let mainScrollView = UIScrollView()
          mainScrollView.delegate = self
          return mainScrollView
      }()
      
      private lazy var detailVC: CTContentDetailController = {
          let detailVC = CTContentDetailController()
          detailVC.delegate = self
          return detailVC
      }()

      private lazy var chapterVC: CTChapterController = {
          let chapterVC = CTChapterController()
          chapterVC.delegate = self
          return chapterVC
      }()
      
      private lazy var navigationBarY: CGFloat = {
          return navigationController?.navigationBar.frame.maxY ?? 0
      }()
      
      private lazy var pageVC: CTPageController = {
          return CTPageController(titles: ["详情", "目录"],
                                     vcs: [detailVC, chapterVC],
                                     pageStyle: .topTabBar)
      }()
      
      private lazy var headView: CTComicHeadView = {
          return CTComicHeadView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarY + 150))
      }()
      
      private var detailStatic: CTDetailStaticModel?
      private var detailRealtime: CTDetailRealtimeModel?
      
      
      convenience init(comicid: Int) {
          self.init()
          self.comicid = comicid
      }
      
      override func viewDidLoad() {
          super.viewDidLoad()
          edgesForExtendedLayout = .top
      }
      
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          navigationController?.setNavigationBarHidden(false, animated: true)
          UIApplication.changeOrientationTo(landscapeRight: false)
          loadData()
      }
      
      
      private func loadData() {
          
          let grpup = DispatchGroup()
          
          grpup.enter()
          ApiLoadingProvider.request(CTApi.detailStatic(comicid: comicid),
                                     model: CTDetailStaticModel.self) { [weak self] (detailStatic) in
                                      self?.detailStatic = detailStatic
                                      self?.headView.detailStatic = detailStatic?.comic
                                      self?.detailVC.detailStatic = detailStatic
                                      self?.chapterVC.detailStatic = detailStatic
                                      grpup.leave()
          }
          
          grpup.enter()
          ApiProvider.request(CTApi.detailRealtime(comicid: comicid),
                              model: CTDetailRealtimeModel.self) { [weak self] (returnData) in
                                  self?.detailRealtime = returnData
                                  self?.headView.detailRealtime = returnData?.comic
                                  
                                  self?.detailVC.detailRealtime = returnData
                                  self?.chapterVC.detailRealtime = returnData
                                 grpup.leave()
          }
          
          grpup.enter()
          ApiProvider.request(CTApi.guessLike, model: CTGuessLikeModel.self) { (returnData) in
              self.detailVC.guessLike = returnData
              grpup.leave()
          }
          
          grpup.notify(queue: DispatchQueue.main) {
              self.detailVC.reloadData()
              self.chapterVC.reloadData()
          }
      }
      
      override func setupLayout(){
          view.addSubview(mainScrollView)
          mainScrollView.snp.makeConstraints { make in
              make.edges.equalTo(self.view.usnp.edges).priority(.low)
              make.top.equalToSuperview()
          }
          
          let contentView = UIView()
          mainScrollView.addSubview(contentView)
          contentView.snp.makeConstraints { make in
              make.edges.equalToSuperview()
              make.width.equalToSuperview()
              make.height.equalToSuperview().offset(-navigationBarY)
          }
          
          addChild(pageVC)
          contentView.addSubview(pageVC.view)
          pageVC.view.snp.makeConstraints { make in make.edges.equalToSuperview() }
          
          mainScrollView.parallaxHeader.view = headView
          mainScrollView.parallaxHeader.height = navigationBarY + 150
          mainScrollView.parallaxHeader.minimumHeight = navigationBarY
          mainScrollView.parallaxHeader.mode = .fill
      }
      
      override func configNavigationBar() {
          super.configNavigationBar()
          navigationController?.barStyle(.clear)
          mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
      }

  

}
extension CTComicController: UIScrollViewDelegate, CTComicViewWillEndDraggingDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.barStyle(.theme)
            navigationItem.title = detailStatic?.comic?.name
        } else {
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.minimumHeight),
                                            animated: true)
        } else if scrollView.contentOffset.y < 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.height),
                                            animated: true)
        }
    }
}

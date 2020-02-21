//
//  CTContentDetailController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTContentDetailController: CTBaseController {
    // 代理
       weak var delegate: CTComicViewWillEndDraggingDelegate?
       
       // 模型
       var detailStatic: CTDetailStaticModel?
       var detailRealtime: CTDetailRealtimeModel?
       var guessLike: CTGuessLikeModel?
       
       private  lazy var tableView: UITableView = {
           let tableView = UITableView(frame: .zero, style: .plain)
           tableView.backgroundColor = UIColor.background
           tableView.delegate = self
           tableView.dataSource = self
           tableView.separatorStyle = .none
           tableView.register(cellType: CTDescriptionTCell.self)
           tableView.register(cellType: CTOtherWorksTCell.self)
           tableView.register(cellType: CTTicketTVCell.self)
           tableView.register(cellType: CTGuessLikeTVCell.self)
           return tableView
       }()
       
       override func viewDidLoad() {
           super.viewDidLoad()
       }
       
       func reloadData() {
           tableView.reloadData()
       }
       
       override func setupLayout() {
           view.addSubview(tableView)
           tableView.snp.makeConstraints { make in
               make.edges.equalTo(self.view.usnp.edges)
           }
       }
}
extension CTContentDetailController: UITableViewDelegate, UITableViewDataSource {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return detailStatic != nil ? 4 : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? 0 : 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CTDescriptionTCell.height(for: detailStatic)
        } else if indexPath.section == 3{
            return 200
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTDescriptionTCell.self)
            cell.model = detailStatic
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTOtherWorksTCell.self)
            cell.model = detailStatic
            return cell
        }else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTTicketTVCell.self)
            cell.model = detailRealtime
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTGuessLikeTVCell.self)
            cell.model = guessLike
            cell.didSelectClosure { [weak self] (comic) in
                let vc = CTComicController(comicid: comic.comic_id)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let vc = CTOtherWorksController(otherWorks: detailStatic?.otherWorks)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return (section == 1 && detailStatic?.otherWorks?.count == 0) ? CGFloat.leastNormalMagnitude : 10
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

//
//  CTHomeRankController.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTHomeRankController: CTBaseController {

    private var rankList = [CTRankingModel]();
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.background
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: CTRankTVCell.self)
        tableView.uHead = URefreshHeader{[weak self]in self?.setupLoadData()}
        tableView.uempty = UEmptyView{[weak self] in self?.setupLoadData()}
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLoadData()
    }
    
    @objc private func setupLoadData(){
        ApiLoadingProvider.request(CTApi.rankList, model: CTRankinglistModel.self) { (returnData) in
            self.tableView.uHead.endRefreshing()
            self.tableView.uempty?.allowShow = true
                       
            self.rankList = returnData?.rankinglist ?? []
            self.tableView.reloadData()
        }
        
    }
    override func setupLayout() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension CTHomeRankController: UITableViewDelegate,UITableViewDataSource {
    
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CTRankTVCell.self)
        cell.model = rankList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankList[indexPath.row]
        let vc = CTComicListController(argCon: model.argCon,
                                          argName: model.argName,
                                          argValue: model.argValue)
        vc.title = "\(model.title!)榜"
        navigationController?.pushViewController(vc, animated: true)
    }
}

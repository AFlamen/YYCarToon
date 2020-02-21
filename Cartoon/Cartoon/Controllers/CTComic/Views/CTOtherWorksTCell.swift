//
//  CTOtherWorksTCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTOtherWorksTCell: CTBaseTableViewCell {

   override init(style: CellStyle, reuseIdentifier: String?) {
          super.init(style: .value1, reuseIdentifier: reuseIdentifier)
          accessoryType = .disclosureIndicator
      }
      
      required init?(coder aDecoder: NSCoder) {
          fatalError("init(coder:) has not been implemented")
      }
      
      var model: CTDetailStaticModel? {
          didSet{
              guard let model = model else { return }
              textLabel?.text = "其他作品"
              detailTextLabel?.text = "\(model.otherWorks?.count ?? 0)本"
              detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
          }
      }
}

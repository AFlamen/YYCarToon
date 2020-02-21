//
//  CTTicketTVCell.swift
//  Cartoon
//
//  Created by yzl on 2020/1/8.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import UIKit

class CTTicketTVCell: CTBaseTableViewCell {

    var model: CTDetailRealtimeModel? {
        didSet {
            guard let model = model else { return }
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ",
                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                                                              NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]))
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.orange,
                             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]),
                        at: 6)
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
    }
    
}

//
//  StringExtension.swift
//  Cartoon
//
//  Created by yzl on 2020/1/7.
//  Copyright © 2020 Y&Y. All rights reserved.
//

import Foundation

extension String {
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        } else {
            return self
        }
    }
}

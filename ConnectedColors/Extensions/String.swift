//
//  String.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

extension String {
    var dateFromShortString: Date? {
        return DateFormatter.shortDate.date(from: self)
    }
}

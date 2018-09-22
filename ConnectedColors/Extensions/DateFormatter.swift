//
//  DateFormatter.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

public extension DateFormatter {
    
    @nonobjc static var shortDate: DateFormatter = {
        $0.locale = .posix
        $0.dateFormat = "yyyy-MM-dd"
        return $0
    }(DateFormatter())
    
}

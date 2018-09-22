//
//  Locale.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import Foundation

public extension Locale {
    public static let enIdentifier: String = "en_US_POSIX"
    
    @nonobjc public static var posix: Locale = {
        return Locale(identifier: enIdentifier)
    }()
}

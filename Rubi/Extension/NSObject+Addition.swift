//
//  NSObject+Addition.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/27.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    public static var className: String {
        return String(describing: self)
    }
    
    public var className: String {
        return type(of: self).className
    }
}

extension NSObject: ClassNameProtocol {}

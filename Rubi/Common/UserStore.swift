//
//  UserStore.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/11/02.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

final class UserStore {
    private enum Key: String {
        case favorite
        case rubiType
    }
    
    static var isHiragana: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.rubiType.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: Key.rubiType.rawValue)
        }
    }
}

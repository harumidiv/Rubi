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
        case hiragana
        case kanji
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
    
    static var hiragana: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.hiragana.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: Key.hiragana.rawValue) as! [String]
        }
    }
    
    static var kanji: [String] {
        set {
            UserDefaults.standard.set(newValue, forKey: Key.kanji.rawValue)
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.array(forKey: Key.kanji.rawValue) as! [String]
        }
    }
}

extension UserStore {
    static func favoriteItemIsNil() -> Bool  {
        //TODO nilチェックの処理
        return true
        
    }
}

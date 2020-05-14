//
//  Constant.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/27.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

struct Constant {
    static let appID = "da756351d7a002a20d2ab1626ada450091a8dc431a5f216fb61d74b609db97e0"
    
    static let apiURL = URL(string: "https://labs.goo.ne.jp/api/hiragana")!
    
    struct request {
        static let json = "application/json"
        static let urlencoded = "application/x-www-form-urlencoded"
        static let type = "Content-Type"
    }
    struct convertType{
        static let hiragana = "hiragana"
        static let katakana = "katakana"
    }
    struct userDeafultKey{
        static let hiragana = "hiragana"
        static let kanji = "kanji"
    }
    
    static let themeColor: UIColor = UIColor(red: 229/255, green: 114/255, blue: 31/255, alpha: 1.0)
}

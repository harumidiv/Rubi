//
//  FavoriteModel.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/29.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol FavoriteModel: class{
    func favoriteSearch() -> [RubiEntity]
    func deleteItem(num: Int) -> [RubiEntity]
}

class FavoriteModelImpl: FavoriteModel {
    let userDefault = UserDefaults.standard
    
    func favoriteSearch() -> [RubiEntity] {
        var rubiEntity:[RubiEntity] = []
        
        if dataIsNil(){return rubiEntity}
        
        let hiragana:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        let kanji:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        for i in 0..<hiragana.count {
            let entity = RubiEntity(rootText: kanji[i], convertTest: hiragana[i], isFavorite: true)
            rubiEntity.append(entity)
        }
        return rubiEntity
    }
    
    func deleteItem(num: Int) -> [RubiEntity] {
        var rubiEntity:[RubiEntity] = []
        
        if dataIsNil(){return rubiEntity}
        
        var hiragana:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        var kanji:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        
        hiragana.remove(at: abs(hiragana.count - num)-1)
        kanji.remove(at: abs(kanji.count - num)-1)
        
        userDefault.set(hiragana, forKey: Constant.userDeafultKey.hiragana)
        userDefault.set(kanji, forKey: Constant.userDeafultKey.kanji)
        userDefault.synchronize()
        
        for i in 0..<hiragana.count {
            let entity = RubiEntity(rootText: kanji[i], convertTest: hiragana[i], isFavorite: true)
            rubiEntity.append(entity)
        }
        return rubiEntity
    }
    
    private func dataIsNil() -> Bool{
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            return true
        }
        return false
    }
}

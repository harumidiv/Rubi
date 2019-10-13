//
//  RubiModel.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol RubiModel: class{
    func requesetAPI(text: String, result:@escaping(String)->())
    func saveItem(rootText:String, convertText: String)
    func removeItem(rootText:String, convertText: String)
    func internetConnectionCheck() -> Bool
    func favoriteCheck(history: [RubiEntity]) -> [RubiEntity]
}


class RubiModelImpl: RubiModel {
    private let userDefault = UserDefaults.standard
    private lazy var request: URLRequest = {
        var request = URLRequest(url: Constant.apiURL )
        request.httpMethod = "POST"
        request.addValue(Constant.request.json, forHTTPHeaderField: Constant.request.type)
        return request
    }()
    
    func requesetAPI(text: String, result:@escaping(String)->()) {
        let postData = PostData(app_id: Constant.appID , sentence: text, output_type: Constant.convertType.hiragana)
        
        guard let uploadData = try? JSONEncoder().encode(postData) else {
            print("json生成に失敗しました")
            return
        }
        request.httpBody = uploadData
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            guard let data = data, let jsonData = try? JSONDecoder().decode(Rubi.self, from: data) else {
                print("json変換に失敗しました")
                return
            }
            result(jsonData.converted)
        }
        task.resume()
    }
    
    func saveItem(rootText: String, convertText: String) {
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            userDefault.set([convertText], forKey: Constant.userDeafultKey.hiragana)
            userDefault.set([rootText], forKey: Constant.userDeafultKey.kanji)
            return
        }
        
        var convertObjects:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        var rootObjecdts:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        
        convertObjects.append(convertText)
        rootObjecdts.append(rootText)
        userDefault.set(convertObjects, forKey: Constant.userDeafultKey.hiragana)
        userDefault.set(rootObjecdts, forKey: Constant.userDeafultKey.kanji)
        userDefault.synchronize()
    }
    
    func removeItem(rootText: String, convertText: String) {
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            print("userDefaultsに値が保存されていません")
            return
        }

        var convertObjects:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        var rootObjecdts:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        
        
        for (i, text) in convertObjects.enumerated() {
            if text == convertText {
                if convertObjects[safe: i] != nil {
                    convertObjects.remove(at: i)
                }
            }
        }
        for (i, text) in rootObjecdts.enumerated() {
            if text == rootText {
                if rootObjecdts[safe: i] != nil {
                    rootObjecdts.remove(at: i)
                }
            }
        }
        
        userDefault.set(convertObjects, forKey: Constant.userDeafultKey.hiragana)
        userDefault.set(rootObjecdts, forKey: Constant.userDeafultKey.kanji)
        userDefault.synchronize()
    }
    
    func internetConnectionCheck() -> Bool {
        
        if Network.isOnline() {
            return true
        }
        return false
    }
    func favoriteCheck(history: [RubiEntity]) -> [RubiEntity] {
        var rubiList = history
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil {
            for i in 0..<rubiList.count {
                rubiList[i].isFavorite = false
            }
            return rubiList
        }
        let convertObjects:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        
        if convertObjects.isEmpty {
            for i in 0..<rubiList.count {
                rubiList[i].isFavorite = false
            }
            return rubiList
        }
        for i in 0..<rubiList.count {
            rubiList[i].isFavorite = false
        }
        convertObjects.forEach { rubi in
            for i in 0..<rubiList.count {
                if rubiList[i].convertTest == rubi {
                    rubiList[i].isFavorite = true
                }
            }
        }
        return rubiList
    }
}

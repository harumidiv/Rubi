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
    private lazy var request: URLRequest = {
        var request = URLRequest(url: Constant.apiURL )
        request.httpMethod = "POST"
        request.addValue(Constant.request.json, forHTTPHeaderField: Constant.request.type)
        return request
    }()
    
    func requesetAPI(text: String, result:@escaping(String)->()) {
        let postData: PostData!
    
        let isHiragana = UserStore.isHiragana
        if isHiragana {
            postData = PostData(app_id: Constant.appID , sentence: text, output_type: Constant.convertType.hiragana)
        } else {
            postData = PostData(app_id: Constant.appID , sentence: text, output_type: Constant.convertType.katakana)
        }
            
        
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
        if UserStore.favoriteItemIsNil() {
            UserStore.hiragana = [convertText]
            UserStore.kanji = [rootText]
            return
        }
        
        var convertObjects:[String] = UserStore.hiragana
        var rootObjecdts:[String] = UserStore.kanji
        
        convertObjects.append(convertText)
        rootObjecdts.append(rootText)
        
        UserStore.hiragana = convertObjects
        UserStore.kanji = rootObjecdts
    }
    
    func removeItem(rootText: String, convertText: String) {
        if UserStore.favoriteItemIsNil() {
            print("userDefaultsに値が保存されていません")
            return
        }

        var convertObjects:[String] = UserStore.hiragana
        var rootObjecdts:[String] = UserStore.kanji
        
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
        UserStore.hiragana = convertObjects
        UserStore.kanji = rootObjecdts
    }
    
    func internetConnectionCheck() -> Bool {
        
        if Network.isOnline() {
            return true
        }
        return false
    }
    func favoriteCheck(history: [RubiEntity]) -> [RubiEntity] {
        var rubiList = history
        if UserStore.favoriteItemIsNil() {
            for i in 0..<rubiList.count {
                rubiList[i].isFavorite = false
            }
            return rubiList
        }
        let convertObjects:[String] = UserStore.hiragana
        
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

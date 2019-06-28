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
}


class RubiModelImpl: RubiModel {
    private lazy var request: URLRequest = {
        var request = URLRequest(url: Constant.apiURL )
        request.httpMethod = "POST"
        request.addValue(Constant.request.json, forHTTPHeaderField: Constant.request.type)
        request.addValue(Constant.request.urlencoded, forHTTPHeaderField: Constant.request.type)
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
}

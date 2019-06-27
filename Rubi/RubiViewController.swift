//
//  RubiViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiViewController: UIViewController {
    
    lazy var presenter: RubiPresenter =  {
        return RubiPresenterImpl(model: RubiModelImpl())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        var request = URLRequest(url: URL(string: "https://labs.goo.ne.jp/api/hiragana")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let postData = PostData(app_id: "da756351d7a002a20d2ab1626ada450091a8dc431a5f216fb61d74b609db97e0", request_id: "record003", sentence: "電光石火", output_type: "hiragana")
        
        
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
            print(jsonData.converted)
        }
        task.resume()
    }
}
struct Rubi:Codable {
    var request_id: String
    var output_type: String
    var converted: String
}

struct PostData: Codable {
    var app_id:String
    var request_id: String
    var sentence: String
    var output_type: String
}

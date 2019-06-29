//
//  RubiPresenter.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol RubiPresenter: class {
    func requestAPI(text: String)
    func saveItem(rootText:String, convertText: String)
    func removeItem(rootText:String, convertText: String)
}

protocol RubiPresenterOutput: class {
    func convertText(hiragana: String)
}


class RubiPresenterImpl: RubiPresenter{
    weak var output: RubiPresenterOutput?
    let model: RubiModel
 
    init(model: RubiModel, output: RubiPresenterOutput) {
        self.model = model
        self.output = output
    }
    func requestAPI(text: String) {
        model.requesetAPI(text: text, result: {rubi in
            self.output?.convertText(hiragana: rubi)
        })
    }
    func saveItem(rootText: String, convertText: String) {
        
    }
    func removeItem(rootText: String, convertText: String) {
        
    }
}

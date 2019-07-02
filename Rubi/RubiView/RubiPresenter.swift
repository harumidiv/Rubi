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
    func internetConnectionCheck() -> Bool
    func favoriteCheck(history: [RubiEntity])
}

protocol RubiPresenterOutput: class {
    func convertText(hiragana: String)
    func showInterntConnectionError()
    func showUpdateHistory(entity: [RubiEntity])
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
        model.saveItem(rootText: rootText, convertText: convertText)
    }
    
    func removeItem(rootText: String, convertText: String) {
        model.removeItem(rootText: rootText, convertText: convertText)
    }
    
    func internetConnectionCheck() -> Bool {
        if model.internetConnectionCheck() {
            return true
        }
        output?.showInterntConnectionError()
        return false
    }
    func favoriteCheck(history: [RubiEntity]) {
        output?.showUpdateHistory(entity: model.favoriteCheck(history: history))
    }
}

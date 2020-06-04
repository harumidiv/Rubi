//
//  RubiPresenter.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol RubiPresenter: class {
    func saveItem(rootText:String, convertText: String)
    func removeItem(rootText:String, convertText: String)
    func internetConnectionCheck() -> Bool
    func favoriteCheck(history: [RubiEntity])
    @discardableResult
    func fire(_ event: RubiEvent, requestText: String?) -> Bool
}

protocol RubiPresenterOutput: class {
    func convertText(hiragana: String)
    func showInterntConnectionError()
    func showUpdateHistory(entity: [RubiEntity])
    func showServerError()
}

class RubiPresenterImpl: RubiPresenter{
    
    var state: RubiState {
        return stateMachine.state
    }
    private var transitions: [Transition<RubiState, RubiEvent>]!
    private var stateMachine: StateMachine<RubiState, RubiEvent>!
    weak var output: RubiPresenterOutput?
    let model: RubiModel
    
    var requestText:String = ""
    var resultString:String?
 
    init(model: RubiModel, output: RubiPresenterOutput) {
        self.model = model
        self.output = output
        
        transitions = [
            //initialize
            Transition<RubiState, RubiEvent>(from: .`init`, to: .loading, by: .load(.refresh), withAction: refresh),
            //loading
            Transition<RubiState, RubiEvent>(from: .loading, to: .success, by: .load(.success), withAction: presentSuccess),
            Transition<RubiState, RubiEvent>(from: .loading, to: .error, by: .load(.error), withAction: presentError),
            //success
            Transition<RubiState, RubiEvent>(from: .success, to: .loading, by: .load(.refresh), withAction: refresh),
            //error
            Transition<RubiState, RubiEvent>(from: .error, to: .loading, by: .load(.refresh), withAction: refresh),
        ]
        stateMachine = StateMachine(initialState: .`init`, transitions: transitions)
    }
    
    @discardableResult
    func fire(_ event: RubiEvent, requestText: String? = nil) -> Bool {
        if let text = requestText {
            self.requestText = text
        }
        return stateMachine.fire(by: event) != nil
    }
    
    private func refresh() {
        model.requesetAPI(text: requestText) { rubi in
            switch rubi {
            case .success(let text):
                self.resultString = text
                self.fire(.load(.success))
            case .failure(_):
                self.fire(.load(.error))
                break
            }
        }
    }
    
    private func presentSuccess() {
        self.output?.convertText(hiragana: resultString ?? "")
    }
    private func presentError() {
        self.output?.showServerError()
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

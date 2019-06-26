//
//  RubiPresenter.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol RubiPresenter: class {
    
}

class RubiPresenterImpl: RubiPresenter{
    let model: RubiModel
    init(model: RubiModel) {
        self.model = model
    }
}

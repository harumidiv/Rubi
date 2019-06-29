//
//  FavoritePresenter.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/29.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation

protocol FavoritePresenter: class{
    func favoriteSearch()
    func deleteItem(num: Int)
}
protocol FavoritePresenterOutput: class{
    func showRubiEntityModel(entity: [RubiEntity])
    func showUpdateFavoriteList(entity: [RubiEntity])
}

class FavoritePresenterImpl: FavoritePresenter {
    weak var output:FavoritePresenterOutput?
    let model: FavoriteModel
    
    init(output: FavoritePresenterOutput, model: FavoriteModel) {
        self.output = output
        self.model = model
    }
    
    func favoriteSearch() {
        output?.showRubiEntityModel(entity: model.favoriteSearch())
    }
    func deleteItem(num: Int) {
        output?.showUpdateFavoriteList(entity: model.deleteItem(num: num))
    }
}

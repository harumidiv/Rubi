//
//  FavoriteViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/29.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: RubiTableViewCell.self)
        }
    }
    
    private lazy var presenter: FavoritePresenter =  {
        return FavoritePresenterImpl(output: self, model: FavoriteModelImpl())
    }()
    
    var rubiEntity: [RubiEntity] = []
    let userDefault = UserDefaults.standard
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.favoriteSearch()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.favoriteSearch()
        tableView.reloadData()
    }
    
    // MARK: - Event
    
    @objc func deleteFavoriteItem(_ sender: UIButton){
        presenter.deleteItem(num: sender.tag)
    }
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rubiEntity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RubiTableViewCell.self, for: indexPath)
        let reverseList:[RubiEntity] = rubiEntity.reversed()
        let item = reverseList[indexPath.row]
        cell.rubiLabel.text = item.convertTest
        cell.kanjiLabel.text = item.rootText
        cell.favoriteButton.setTitle("⭐️", for: .normal)
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action:  #selector(deleteFavoriteItem(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

// MARK: - Extension FavoritePresenterOutpu

extension FavoriteViewController: FavoritePresenterOutput {
    func showUpdateFavoriteList(entity: [RubiEntity]) {
        rubiEntity = entity
        tableView.reloadData()
    }
    
    func showRubiEntityModel(entity: [RubiEntity]) {
        rubiEntity = entity
    }
}

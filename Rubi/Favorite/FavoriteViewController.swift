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
    var rubiEntity: [RubiEntity] = []
    let userDefault = UserDefaults.standard
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            return
        }
        let hiragana:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        let kanji:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        for i in 0..<hiragana.count {
            let entity = RubiEntity(rootText: kanji[i], convertTest: hiragana[i])
            rubiEntity.append(entity)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        rubiEntity.removeAll()
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            return
        }
        let hiragana:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        let kanji:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]
        for i in 0..<hiragana.count {
            let entity = RubiEntity(rootText: kanji[i], convertTest: hiragana[i])
            rubiEntity.append(entity)
        }
        tableView.reloadData()
    }
    
    // MARK: - Event
    
    @objc func deleteFavoriteItem(_ sender: UIButton){
        print("押されたよ\(sender.tag)")
        rubiEntity.removeAll()
        if userDefault.object(forKey: Constant.userDeafultKey.hiragana) == nil, userDefault.object(forKey: Constant.userDeafultKey.kanji) == nil {
            return
        }
        var hiragana:[String] = userDefault.array(forKey: Constant.userDeafultKey.hiragana) as! [String]
        var kanji:[String] = userDefault.array(forKey: Constant.userDeafultKey.kanji) as! [String]

        hiragana.remove(at: abs(hiragana.count - sender.tag)-1)
        kanji.remove(at: abs(kanji.count - sender.tag)-1)
        
        userDefault.set(hiragana, forKey: Constant.userDeafultKey.hiragana)
        userDefault.set(kanji, forKey: Constant.userDeafultKey.kanji)
        userDefault.synchronize()
        
        for i in 0..<hiragana.count {
            let entity = RubiEntity(rootText: kanji[i], convertTest: hiragana[i])
            rubiEntity.append(entity)
        }
        tableView.reloadData()
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

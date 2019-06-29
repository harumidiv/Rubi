//
//  RubiViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(cellType: RubiTableViewCell.self)
        }
    }
    @IBOutlet weak var rubiTextField: UITextField! {
        didSet {
            rubiTextField.delegate = self
        }
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    
    @IBOutlet weak var rubiLabel: UILabel!
    lazy var presenter: RubiPresenter =  {
        return RubiPresenterImpl(model: RubiModelImpl(), output: self)
    }()
    
    var rubiList:[RubiEntity] = []
    var rootText: String?
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        title = "Rubi 翻訳"
    }
    @objc func saveFavoriteItem(_ button: UIButton){
        let reverseList:[RubiEntity] = rubiList.reversed()
        let item = reverseList[button.tag]
        if button.titleLabel?.text == "☆" {
            button.setTitleColor(.yellow, for: .normal)
            button.setTitle("★", for: .normal)
            saveItem(rootText: item.rootText, convertText: item.convertTest)
        } else {
            button.setTitleColor(.black, for: .normal)
            button.setTitle("☆", for: .normal)
            removeItem(rootText: item.rootText, convertText: item.convertTest)
        }
    }
    
    private func saveItem(rootText: String, convertText: String){
        presenter.saveItem(rootText: rootText, convertText: convertText)
    }
    
    private func removeItem(rootText: String, convertText: String) {
        presenter.removeItem(rootText: rootText, convertText: convertText)
    }
}

extension RubiViewController: RubiPresenterOutput {
    func convertText(hiragana: String) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = true
            self.rubiLabel.isHidden = false
            self.rubiLabel.text = hiragana
            self.rubiList.append(RubiEntity(rootText: self.rootText!, convertTest: hiragana))
            self.tableView.reloadData()
        }
    }
}

extension RubiViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.count > 0 else {
            rubiLabel.text = "⚠️文字を入力してください"
            return true
        }
        rootText = text
        indicator.isHidden = false
        indicator.startAnimating()
        rubiLabel.isHidden = true
        presenter.requestAPI(text: text)
        textField.resignFirstResponder()
        return true
    }
}

extension RubiViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rubiList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RubiTableViewCell.self, for: indexPath)
        let reverseList:[RubiEntity] = rubiList.reversed()
        let item = reverseList[indexPath.row]
        cell.rubiLabel.text = item.convertTest
        cell.kanjiLabel.text = item.rootText
        cell.favoriteButton.tag = indexPath.row
        cell.favoriteButton.addTarget(self, action:  #selector(saveFavoriteItem), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}


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
    @IBOutlet weak var rubiTextView: UITextView! {
        didSet {
            rubiTextView.delegate = self
        }
    }
    @IBOutlet weak var indicator: UIActivityIndicatorView! {
        didSet {
            indicator.isHidden = true
        }
    }
    
    @IBOutlet weak var rubiLabel: UILabel! {
        didSet {
            rubiLabel.text = ""
        }
    }
    
    private lazy var presenter: RubiPresenter =  {
        return RubiPresenterImpl(model: RubiModelImpl(), output: self)
    }()
    
    var rubiList:[RubiEntity] = []
    var rootText: String = ""
    let userDefault = UserDefaults.standard

    // MAKR: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        title = "Rubi 翻訳"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rubiLabel.text = ""
        rubiTextView.text = "ひらがなに変換したい文字を入力してください"
        rubiTextView.textColor = UIColor.gray
    }
    
    // MARK: - Event
    
    @objc func saveFavoriteItem(_ button: UIButton){
        let reverseList:[RubiEntity] = rubiList.reversed()
        let item = reverseList[button.tag]
        if button.titleLabel?.text == "☆" {
            button.setTitleColor(.yellow, for: .normal)
            button.setTitle("⭐️", for: .normal)
            saveItem(rootText: item.rootText, convertText: item.convertTest)
        } else {
            button.setTitleColor(.black, for: .normal)
            button.setTitle("☆", for: .normal)
            removeItem(rootText: item.rootText, convertText: item.convertTest)
        }
    }
    
    // MARK: - PrivateMethod
    
    private func saveItem(rootText: String, convertText: String){
        presenter.saveItem(rootText: rootText, convertText: convertText)
    }
    
    private func removeItem(rootText: String, convertText: String) {
        presenter.removeItem(rootText: rootText, convertText: convertText)
    }
}

// MARK: - Extension RubiPresenterOutput

extension RubiViewController: RubiPresenterOutput {
    func convertText(hiragana: String) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = true
            self.rubiLabel.isHidden = false
            self.rubiLabel.text = hiragana
            self.rubiList.append(RubiEntity(rootText: self.rootText, convertTest: hiragana))
            self.tableView.reloadData()
        }
    }
}

// MARK: - Extension UITextViewDelegate

extension RubiViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        rubiTextView.textColor = .black
        if (text == "\n") {
            guard let text = rubiTextView.text, text.count > 0 else {
                rubiTextView.resignFirstResponder()
                rubiLabel.text = "⚠️文字を入力してください"
                return true
            }
            rootText = text
            indicator.isHidden = false
            indicator.startAnimating()
            rubiLabel.isHidden = true
            presenter.requestAPI(text: text)
            rubiTextView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}

// MARK: - Extension UITableViewDelegate, UITableViewDataSource

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


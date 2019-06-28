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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
        title = "Rubi 翻訳"
    }
}

extension RubiViewController: RubiPresenterOutput {
    func convertText(hiragana: String) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = true
            self.rubiLabel.isHidden = false
            self.rubiLabel.text = hiragana
        }
    }
}

extension RubiViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text, text.count > 0 else {
            print("からです")
            rubiLabel.text = "文字を入力してください"
            return true
        }
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: RubiTableViewCell.self, for: indexPath)
        cell.rubiLabel.text = "でんせつ"
        cell.kanjiLabel.text = "伝説"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}


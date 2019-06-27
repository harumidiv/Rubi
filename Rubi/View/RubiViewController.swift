//
//  RubiViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiViewController: UIViewController {
    @IBOutlet weak var rubiTextField: UITextField! {
        didSet {
            rubiTextField.delegate = self
        }
    }
    
    @IBOutlet weak var rubiLabel: UILabel!
    lazy var presenter: RubiPresenter =  {
        return RubiPresenterImpl(model: RubiModelImpl(), output: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
}

extension RubiViewController: RubiPresenterOutput {
    func convertText(hiragana: String) {
        DispatchQueue.main.async {
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
        
        presenter.requestAPI(text: text)
        textField.resignFirstResponder()
        return true
    }
}

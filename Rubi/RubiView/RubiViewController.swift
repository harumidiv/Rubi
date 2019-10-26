//
//  RubiViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView! {
        didSet {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
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
            rubiLabel.lineBreakMode = .byCharWrapping
        }
    }
    let rubiTypeList = ["ひらがな", "カタカナ"]
    
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
        self.navigationItem.title = "Rubi 翻訳"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        favoriteCheck()
        tableView.reloadData()
        rubiLabel.text = ""
        rubiTextView.text = "ひらがなに変換したい文字を入力してください"
        rubiTextView.textColor = UIColor.gray
    }
    
    // MARK: - Event
    
    @objc func saveFavoriteItem(_ button: UIButton){
        let reverseList:[RubiEntity] = rubiList.reversed()
        let item = reverseList[button.tag]
         let num = rubiList.count - button.tag - 1
        if button.titleLabel?.text == "☆" {
            button.setTitleColor(.yellow, for: .normal)
            button.setTitle("⭐️", for: .normal)
            rubiList[num].isFavorite = true
            saveItem(rootText: item.rootText, convertText: item.convertTest)
        } else {
            button.setTitleColor(.black, for: .normal)
            button.setTitle("☆", for: .normal)
            rubiList[num].isFavorite = false
            removeItem(rootText: item.rootText, convertText: item.convertTest)
        }
    }
    @IBAction func recordingTapped(_ sender: Any) {
        let vc = RecordingViewController()
        vc.dismissHandler = { text in
            self.rootText = text
            self.rubiTextView.text = text
            self.rubiTextView.textColor = .black
            self.presenter.requestAPI(text: text)
            vc.dismiss(animated: true, completion: nil)
            self.rubiTextView.resignFirstResponder()
        }
     
        present(vc, animated: true, completion: nil)
    }
    @IBAction func pictureTapped(_ sender: Any) {
        let vc = ImageRecognitionViewController()
        vc.dismissHandler = {text in
            self.rootText = text
            self.rubiTextView.text = text
            self.rubiTextView.textColor = .black
            self.presenter.requestAPI(text: text)
            vc.dismiss(animated: true, completion: nil)
            self.rubiTextView.resignFirstResponder()
            
        }
        present(vc, animated: true, completion: nil)
    }
    @IBAction func handwriteingTapped(_ sender: Any) {
        let vc = HandritingRecognitionViewController()
        present(vc, animated: true, completion: nil)
    }
    
    
    // MARK: - PrivateMethod
    
    private func favoriteCheck(){
        presenter.favoriteCheck(history: rubiList)
    }
    
    private func saveItem(rootText: String, convertText: String){
        presenter.saveItem(rootText: rootText, convertText: convertText)
    }
    
    private func removeItem(rootText: String, convertText: String) {
        presenter.removeItem(rootText: rootText, convertText: convertText)
    }
}

// MARK: - Extension RubiPresenterOutput

extension RubiViewController: RubiPresenterOutput {
    func showInterntConnectionError() {
        rubiTextView.resignFirstResponder()
        showInformation(message: "翻訳ができません。インターネットに接続していません。", buttonText: "閉じる")
        rubiLabel.text = "⚠️インターネットに接続してください"
        
    }
    
    func convertText(hiragana: String) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = true
            self.rubiLabel.isHidden = false
            self.rubiLabel.text = hiragana
            self.rubiList.append(RubiEntity(rootText: self.rootText, convertTest: hiragana, isFavorite: false))
            self.tableView.reloadData()
        }
    }
    
    func showUpdateHistory(entity: [RubiEntity]) {
        rubiList = entity
    }
}

// MARK: - Extension UITextViewDelegate

extension RubiViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        rubiTextView.textColor = .black
        if (text == "\n") {
            
            if !presenter.internetConnectionCheck() {
                return true
            }
            
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
        if item.isFavorite {
            cell.favoriteButton.setTitleColor(.yellow, for: .normal)
            cell.favoriteButton.setTitle("⭐️", for: .normal)
        } else {
            cell.favoriteButton.setTitleColor(.black, for: .normal)
            cell.favoriteButton.setTitle("☆", for: .normal)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

extension RubiViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return rubiTypeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return rubiTypeList[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let isHiragana: Bool
        if row == 0 {
            isHiragana = true
        } else {
            isHiragana = false
        }
        userDefault.set(isHiragana, forKey: "rubiType")
    }
    
}

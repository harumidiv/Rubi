//
//  ImageRecognitionViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/23.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit
import Lottie

class ImageRecognitionViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var indicator: AnimationView! {
        didSet {
            indicator.isHidden = true
            indicator.animation = Animation.named("loading")
            indicator.loopMode = .loop
        }
    }
    
    @IBOutlet weak var recognizeTextView: UITextView! {
        didSet {
            recognizeTextView.delegate = self
            recognizeTextView.text = "No Image をタップして画像を選択してください"
        }
    }
    @IBOutlet weak var userPhoto: UIImageView! {
        didSet {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            picker.delegate = self
        }
    }
    var dismissHandler: ((String) -> Void)?
    var picker: UIImagePickerController! = UIImagePickerController()

    private lazy var presentor: ImageRecognitionPresentor = {
        return ImageRecognitionPresentorImpl(model: ImageRecognitionModelImpl(), output: self)
    }()
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    // MARK: - Event
    
    @IBAction func dismissView(_ sender: Any) {
        dismissHandler?(recognizeTextView.text)
    }
    @IBAction func imageTapped(_ sender: Any) {
        recognizeTextView.text = ""
        present(picker, animated: true, completion: nil)
    }

}
// MARK: - Extension ImageRecognitionPresentorOutput

extension ImageRecognitionViewController: ImageRecognitionPresentorOutput {
    func showRecognitionMessage(message: String) {
        DispatchQueue.main.async {
            self.indicator.isHidden = true
            self.indicator.stop()
            self.recognizeTextView.text = message
            self.dismissButton.isHidden = false
        }
    }
}

// MARK: - Extension 

extension ImageRecognitionViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            userPhoto.image = image
            indicator.isHidden = false
            indicator.play()
            
            //メインスレッドだと固まるのでサブスレッドで画像の認識処理を行う
            let userQueue = DispatchQueue.global(qos: .userInitiated)
            userQueue.async {
                self.presentor.recognition(image: image)
            }
            
        } else{
            self.showInformation(message: "画像の解析に失敗しました、正しい画像を選択してください", buttonText: "閉じる")
        }

        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageRecognitionViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
        self.recognizeTextView.resignFirstResponder()
            return false
        }
        return true
    }
}

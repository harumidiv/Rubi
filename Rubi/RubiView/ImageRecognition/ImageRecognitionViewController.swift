//
//  ImageRecognitionViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/23.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit


class ImageRecognitionViewController: UIViewController {

    
    @IBOutlet weak var userPhoto: UIImageView! {
        didSet {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary

            //デリゲートを設定する
            picker.delegate = self

            //現れるピッカーNavigationBarの文字色を設定する
            picker.navigationBar.tintColor = UIColor.white

            //現れるピッカーNavigationBarの背景色を設定する
            picker.navigationBar.barTintColor = UIColor.gray
        }
    }
    var picker: UIImagePickerController! = UIImagePickerController()

    private lazy var presentor: ImageRecognitionPresentor = {
        return ImageRecognitionPresentorImpl(model: ImageRecognitionModelImpl(), output: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        
        //ピッカーを表示する
        present(picker, animated: true, completion: nil)
    }
}
// MARK: - Extension ImageRecognitionPresentorOutput

extension ImageRecognitionViewController: ImageRecognitionPresentorOutput {
    func showRecognitionMessage(message: String) {
        DispatchQueue.main.async {
            //TODO 文字を反映する
            self.view.backgroundColor = .brown
        }
        print(message)
    }
}

// MARK: - Extension 

extension ImageRecognitionViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){

        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           
            userPhoto.image = image
            let userQueue = DispatchQueue.global(qos: .userInitiated)
            userQueue.async {
                self.presentor.recognition(image: image)
            }
            
        } else{
            self.showInformation(message: "画像の解析に失敗しました、正しい画像を選択してください", buttonText: "閉じる")
            print("Error")
        }

        self.dismiss(animated: true, completion: nil)
    }
}

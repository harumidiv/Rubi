//
//  ImageRecognitionViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/23.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit
import SwiftyTesseract

class ImageRecognitionViewController: UIViewController {

    let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let image = UIImage(named: "sample.jpeg") else { return }

         swiftyTesseract.performOCR(on: image) { recognizedString in
             guard let text = recognizedString else { return }
             print("\(text)")

        }
    }
}

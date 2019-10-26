//
//  ImageRecognitionModel.swift
//  
//
//  Created by 佐川晴海 on 2019/10/26.
//

import Foundation
import UIKit
import SwiftyTesseract

protocol ImageRecognitionModel {
    func recognition(image: UIImage, completion: @escaping (String)->())
}

class ImageRecognitionModelImpl: ImageRecognitionModel {
        private let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    
    func recognition(image: UIImage, completion: @escaping (String) -> ()) {
        swiftyTesseract.performOCR(on: image) { recognizedString in
             guard let text = recognizedString else { return }
            completion(text)

        }
    }
    
}

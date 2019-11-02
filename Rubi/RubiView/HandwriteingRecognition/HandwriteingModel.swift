//
//  HandwriteingModel.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/11/02.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import UIKit
import SwiftyTesseract

protocol HandwriteingModel {
    func recognition(image: UIImage, completion: @escaping (String)->())
}

class HandwriteingModelImpl: HandwriteingModel {
    private let swiftyTesseract = SwiftyTesseract(language: RecognitionLanguage.japanese)
    
    func recognition(image: UIImage, completion: @escaping (String) -> ()) {
        swiftyTesseract.performOCR(on: image) { recognizedString in
            guard let text = recognizedString else { return }
            completion(text)
        }
    }
}

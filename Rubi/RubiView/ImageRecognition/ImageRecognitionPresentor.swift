//
//  ImageRecognitionPresentor.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import UIKit

protocol ImageRecognitionPresentor {
    func recognition(image: UIImage)
}
protocol ImageRecognitionPresentorOutput: AnyObject {
    func showRecognitionMessage(message: String)
}

class ImageRecognitionPresentorImpl: ImageRecognitionPresentor {
    
    weak var output: ImageRecognitionPresentorOutput?
    let model: ImageRecognitionModel
    
    init(model: ImageRecognitionModel,output: ImageRecognitionPresentorOutput) {
        self.output = output
        self.model = model
    }
    
    func recognition(image: UIImage) {
        model.recognition(image: image) { text in
            self.output?.showRecognitionMessage(message: text)
        }
    }
}

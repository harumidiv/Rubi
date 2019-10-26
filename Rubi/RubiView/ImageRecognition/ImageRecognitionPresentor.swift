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
protocol ImageRecognitionPresentorOutput {
    func showRecognitionMessage(message: String)
}

class ImageRecognitionPresentorImpl: ImageRecognitionPresentor {
    func recognition(image: UIImage) {
        
    }
}

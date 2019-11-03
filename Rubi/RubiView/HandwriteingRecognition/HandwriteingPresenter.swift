//
//  HandwriteingPresenter.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/11/02.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import UIKit

protocol HandwriteingPresenter {
    func recognition(image: UIImage)
}

protocol HandwriteingPresenterOutput: class {
    func showRecognitionMessage(message: String)
}

class HandwriteingPresenterImpl: HandwriteingPresenter {
    weak var output: HandwriteingPresenterOutput?
    let model: HandwriteingModel
    
    init(output: HandwriteingPresenterOutput, model: HandwriteingModel) {
        self.output = output
        self.model = model
    }
    func recognition(image: UIImage) {
        model.recognition(image: image) { text in
            runOnMain {
                self.output?.showRecognitionMessage(message: text)
            }
        }
    }
    
    
}

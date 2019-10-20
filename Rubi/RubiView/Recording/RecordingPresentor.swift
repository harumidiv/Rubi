//
//  RecordingPresentor.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/20.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import UIKit

protocol RecordingPresenter {
    func startRecording()
    func stopRecording()
}

class RecordingPresentorImpl: RecordingPresenter {
    lazy var model: RecordingModel = {
            return RecordingModelImpl(output: self)
    }()
    
    func startRecording() {
        try? model.startRecording()
    }
    
    func stopRecording() {
        
    }
    
    
}

extension RecordingPresentorImpl: RecordingModelOutput {
    func RecordingText(text: String) -> String {
        return ""
    }

}

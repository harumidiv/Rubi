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

protocol RecordingPresentorOutput: class{
    func recordingText(text: String)
}

class RecordingPresentorImpl: RecordingPresenter {
    lazy var model: RecordingModel = {
        return RecordingModelImpl(output: self)
    }()
    weak var output: RecordingPresentorOutput?
    
    init(output: RecordingPresentorOutput) {
        self.output = output
    }
    
    func startRecording() {
        try? model.startRecording()
    }
    
    func stopRecording() {
        model.stopRecording()
    }
    
    
}

extension RecordingPresentorImpl: RecordingModelOutput {
    func recordingText(text: String){
        output?.recordingText(text: text)
    }

}

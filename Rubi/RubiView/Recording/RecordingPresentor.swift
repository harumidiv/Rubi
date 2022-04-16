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
    func checkMicrophonePermission()
}

protocol RecordingPresentorOutput: AnyObject{
    func recordingText(text: String)
    func permissionState(permissin: Bool)
}

class RecordingPresentorImpl: RecordingPresenter {
    func checkMicrophonePermission() {
        model.checkMicrophonePermission() { result in
            self.output?.permissionState(permissin: result)
        }
    }
    
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

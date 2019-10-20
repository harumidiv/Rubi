//
//  RecordingModel.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/20.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import Foundation
import Speech

protocol RecordingModel {
    func startRecording() throws
    func stopRecording()
}

protocol RecordingModelOutput: class {
    func RecordingText(text: String) -> String
}

class RecordingModelImpl: RecordingModel {
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    let output: RecordingModelOutput
    
    init(output: RecordingModelOutput) {
        self.output = output
        
        requestRecognizerAutholization()
    }
    
    private func requestRecognizerAutholization(){
        //TODO ハンドリング処理を入れる
        SFSpeechRecognizer.requestAuthorization { (status) in
            OperationQueue.main.addOperation {
                    switch status {
                    case .authorized:   // 許可OK
//                        self.recordButton.isEnabled = true
//                        self.recordButton.backgroundColor = UIColor.blue
                        break
                    case .denied:       // 拒否
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("録音許可なし", for: .disabled)
                        break
                    case .restricted:   // 限定
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("このデバイスでは無効", for: .disabled)
                        break
                    case .notDetermined:// 不明
//                        self.recordButton.isEnabled = false
//                        self.recordButton.setTitle("録音機能が無効", for: .disabled)
                        break
                    }
            }
        }
    }
    
    func startRecording() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let `self` = self else { return }

            var isFinal = false

            if let result = result {
                print(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }

            if error != nil || isFinal {
                self.audioEngine.stop()
                self.audioEngine.inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }
    
    func stopRecording() {
        audioEngine.stop()
        recognitionRequest?.endAudio()
    }
    
}

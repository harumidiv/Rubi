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
    func checkMicrophonePermission(result: @escaping (Bool)->())
}

protocol RecordingModelOutput: AnyObject {
    func recordingText(text: String)
}

class RecordingModelImpl: RecordingModel {
    
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    let output: RecordingModelOutput
    
    init(output: RecordingModelOutput) {
        self.output = output
    }
    
    func checkMicrophonePermission(result: @escaping (Bool)->()) {
        var permission:Bool = false

        SFSpeechRecognizer.requestAuthorization { (status) in
            OperationQueue.main.addOperation {
                    switch status {
                    case .authorized:   // 許可OK
                        result(true)
                    case .denied:       // 拒否
                        result(false)
                    case .restricted:   // 限定
                        result(false)
                    case .notDetermined:// 不明
                        result(false)
                    @unknown default:
                        result(false)
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
//                print(result.bestTranscription.formattedString)
                self.output.recordingText(text: result.bestTranscription.formattedString)
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

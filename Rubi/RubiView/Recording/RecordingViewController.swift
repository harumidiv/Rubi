//
//  RecordingViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/20.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var recordingLabel: UILabel!
    var dismissHandler: ((String) -> Void)?
    var recordText:String = ""
    
    lazy var presentor: RecordingPresenter = {
        return RecordingPresentorImpl(output: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Event

    @IBAction func recordingStart(_ sender: Any) {
        print("start")
        recordingLabel.text = "手を離すと録画が止まります"
        presentor.startRecording()
    }
    
    @IBAction func recordingStop(_ sender: Any) {
        presentor.stopRecording()
        recordingLabel.text = "タップすると録画が始まります"
        //Google翻訳のような音を鳴らしたい
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false){_ in
            self.dismissHandler?(self.recordText)
        }
        
        print("stop")
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - RecordingPresentorOutput
extension RecordingViewController: RecordingPresentorOutput {
    
    func recordingText(text: String) {
        recordText = text
        resultLabel.text = text
    }
    
    
}

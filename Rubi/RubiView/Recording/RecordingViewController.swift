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
    
    lazy var presentor: RecordingPresenter = {
        return RecordingPresentorImpl(output: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Event

    @IBAction func recordingStart(_ sender: Any) {
        print("start")
        presentor.startRecording()
    }
    
    @IBAction func recordingStop(_ sender: Any) {
        presentor.stopRecording()
        print("stop")
    }
    
    
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - RecordingPresentorOutput
extension RecordingViewController: RecordingPresentorOutput {
    
    func recordingText(text: String) {
        resultLabel.text = text
    }
    
    
}

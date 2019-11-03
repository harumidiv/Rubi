//
//  HandritingRecognitionViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/23.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit
import Sketch

class HandritingRecognitionViewController: UIViewController {

    @IBOutlet weak var sketchView: SketchView! {
        didSet {
            sketchView.drawTool = .pen
            sketchView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 0.9)
        }
    }
    @IBOutlet weak var translationButton: UIButton!
    @IBOutlet weak var recognizeButton: UIButton!
    @IBOutlet weak var resultText: UILabel!
    
    lazy var presenter: HandwriteingPresenter = {
        return HandwriteingPresenterImpl(output: self, model: HandwriteingModelImpl())
    }()
    
    var translationMessage: String = ""
    var dismissHandler: ((String) -> Void)?
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Event
    
    @IBAction func recognize(_ sender: Any) {
        self.createImage()
        sketchView.clear()
        translationButton.isHidden = true
        recognizeButton.isHidden = true
    }
    
    @IBAction func translation(_ sender: Any) {
        dismissHandler?(translationMessage)
    }
    
    // MARK: - PrivateMethod
    private func createImage() {
           let image = UIGraphicsImageRenderer(size: sketchView.bounds.size).image { context in
               sketchView.layer.render(in: context.cgContext)
           }
           presenter.recognition(image: image)
       }
    
}

// MARK: - Extension HandwriteingPresenterOutput

extension HandritingRecognitionViewController: HandwriteingPresenterOutput {
    func showRecognitionMessage(message: String) {
        resultText.text = message
        translationMessage = message
        DispatchQueue.main.async {
            self.translationButton.isHidden = false
            self.recognizeButton.isHidden = false
        }
    }
}

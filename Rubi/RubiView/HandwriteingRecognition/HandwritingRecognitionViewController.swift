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
    
    lazy var presenter: HandwriteingPresenter = {
        return HandwriteingPresenterImpl(output: self, model: HandwriteingModelImpl())
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO ボタンが押された時に直す
        Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.view.backgroundColor = .brown
            self.createImage()
        }
        
    }
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
        print(message)
    }
    
    
}

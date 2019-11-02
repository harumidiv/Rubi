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
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { _ in
            self.createImage()
        }
        
    }
    func createImage() {
        let image = UIGraphicsImageRenderer(size: sketchView.bounds.size).image { context in
            sketchView.layer.render(in: context.cgContext)
        }
    }
    
}

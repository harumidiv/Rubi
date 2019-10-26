//
//  ImageRecognitionViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/10/23.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit


class ImageRecognitionViewController: UIViewController {


    private lazy var presentor: ImageRecognitionPresentor = {
        return ImageRecognitionPresentorImpl(model: ImageRecognitionModelImpl(), output: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green


    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let image = UIImage(named: "sample.jpeg") else { return }
                presentor.recognition(image: image)
    }
}

extension ImageRecognitionViewController: ImageRecognitionPresentorOutput {
    func showRecognitionMessage(message: String) {
        self.view.backgroundColor = .white
        print(message)
    }
}

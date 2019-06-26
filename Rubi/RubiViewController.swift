//
//  RubiViewController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/26.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class RubiViewController: UIViewController {
    
    lazy var presenter: RubiPresenter =  {
        return RubiPresenterImpl(model: RubiModelImpl())
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
}

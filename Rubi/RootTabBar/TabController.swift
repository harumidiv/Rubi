//
//  TabController.swift
//  Rubi
//
//  Created by 佐川晴海 on 2019/06/29.
//  Copyright © 2019 佐川晴海. All rights reserved.
//

import UIKit

class TabController: UITabBarController {
    
    init(){
        super.init(nibName: String(describing: TabController.self), bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewControllers: [UIViewController] = []
        
        let firstViewController = UINavigationController(rootViewController:RubiViewController())
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.history, tag: 1)
        viewControllers.append(firstViewController)
        
        
        let secondViewController = FavoriteViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.favorites, tag: 2)
        viewControllers.append(secondViewController)
        self.setViewControllers(viewControllers, animated: false)
        
        // 0だけだと選択されないので1にしてから0に
        self.selectedIndex = 1
        self.selectedIndex = 0
    }
}

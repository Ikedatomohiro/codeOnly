//
//  TabBarViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/17.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc = ViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        let nv = UINavigationController(rootViewController: vc)
        let vc2 = NextViewController()
        vc2.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        let nv2 = UINavigationController(rootViewController: vc2)
        setViewControllers([nv, nv2], animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

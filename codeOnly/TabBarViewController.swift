//
//  TabBarViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/17.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit



class TabBarViewController: UITabBarController {
    
    fileprivate let nav1VC = UINavigationController(rootViewController: CollectionViewController())
    fileprivate let nav2VC = UINavigationController(rootViewController: ViewController())
    fileprivate let nav3VC = UINavigationController(rootViewController: StackViewController())
    
    override func viewDidLoad() {
        
    }

}

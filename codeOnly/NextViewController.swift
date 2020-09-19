//
//  NextViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/08/26.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    var t: String?
    var label = UILabel()
    
    init(t: String?) {
        self.t = t
        super.init(nibName: nil, bundle: nil)
        label.text = t
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        navigationItem.title = "NextView"
    }
    
    
    func setup(user: User) {
        
    }
}

struct User {
    var id: Int
    var name: String
    
//    init(id: Int, name: String) {
//        self.id = id
//        self.name = name
//    }
}

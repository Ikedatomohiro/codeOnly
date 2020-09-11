//
//  LayoutController.swift
//  codeOnly
//
//  Created by 杉崎圭 on 2020/09/01.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit

class LayoutController: UIViewController {
    
    let box1 = UIView()
    let box2 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(box1)
        box1.backgroundColor = .blue
        box1.translatesAutoresizingMaskIntoConstraints = false
        box1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        box1.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        box1.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        box1.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
        view.addSubview(box2)
        box2.backgroundColor = .red
        box2.translatesAutoresizingMaskIntoConstraints = false
        box2.topAnchor.constraint(equalTo: box1.topAnchor).isActive = true
        box2.leadingAnchor.constraint(equalTo: box1.leadingAnchor).isActive = true
        box2.bottomAnchor.constraint(equalTo: box1.centerYAnchor).isActive = true
        box2.trailingAnchor.constraint(equalTo: box1.centerXAnchor).isActive = true
    }
}

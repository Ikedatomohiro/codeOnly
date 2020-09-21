//
//  NextViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/08/26.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    fileprivate var titleText: String?
    fileprivate var label = UILabel()
    fileprivate var titleTextField = UITextField()
    
    init(titleText: String?) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
        label.text = titleText
        print(titleText as Any)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupLabel()
        setupTextField()
        navigationItem.title = "NextView"
    }
    
    func setupLabel() {
        view.addSubview(label)
        label.text = titleText
        label.textColor = .blue
        label.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 80, left: 0, bottom: 0, right: 0))
    }
    
    func setupTextField() {
        view.addSubview(titleTextField)
        titleTextField.text = titleText
        titleTextField.anchor(top: label.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        titleTextField.backgroundColor = .white
        
        
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

extension NextViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

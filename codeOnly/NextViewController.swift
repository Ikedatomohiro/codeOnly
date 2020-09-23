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
    fileprivate var titleTextField = UITextField()
    fileprivate var commentTextView = UITextView()
    fileprivate var topicSubmitButton = UIButton()
    
    init(titleText: String?) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
        print(titleText as Any)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupTextField()
        setupCommentTextView()
        setupTopicSubmitButton()
        navigationItem.title = "NextView"
    }
    
    func setupTextField() {
        view.addSubview(titleTextField)
        titleTextField.text = titleText
        titleTextField.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 10, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        titleTextField.backgroundColor = .white
        
        
    }
    
    func setupCommentTextView() {
        view.addSubview(commentTextView)
        commentTextView.anchor(top: titleTextField.layoutMarginsGuide.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 10), size: .init(width: 200, height: 100))
        commentTextView.backgroundColor = .white
    }
    
    func setupTopicSubmitButton() {
        view.addSubview(topicSubmitButton)
        topicSubmitButton.anchor(top: commentTextView.layoutMarginsGuide.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0), size: .init(width: 30, height: 30))
        topicSubmitButton.backgroundColor = .green
        topicSubmitButton.setTitle("更新", for: UIControl.State.normal)
        topicSubmitButton.addTarget(self, action: #selector(updateTopic), for: .touchUpInside)
        
        
    }
    
    @objc func updateTopic() {
        
        
        
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

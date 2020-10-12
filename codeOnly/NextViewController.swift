//
//  NextViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/08/26.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NextViewController: UIViewController {

    fileprivate var topicId: String?
    fileprivate var titleText: String?
    fileprivate var titleTextField = UITextField()
    fileprivate var commentTextView = UITextView()
    fileprivate var topicSubmitButton = UIButton()
    fileprivate var messageText = UITextField()
    fileprivate let db = Firestore.firestore()
    fileprivate var handle:AuthStateDidChangeListenerHandle?
    fileprivate var userId:String? = Auth.auth().currentUser?.uid

    init(titleText: String?) {
        self.titleText = titleText
        super.init(nibName: nil, bundle: nil)
        print(titleText as Any)
    }
    init(topicId: String?) {
        self.topicId = topicId
        super.init(nibName: nil, bundle: nil)
        print(topicId as Any)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        logInCheck()
        setupTextField()
        setupCommentTextView()
        setupTopicSubmitButton()
        setupMessageTextField()
        setTopicData()
        navigationItem.title = "NextView"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func logInCheck() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                self.userId = Auth.auth().currentUser!.uid
                print(self.userId!)
            } else {
                print("ログインしていません")
            }
        }
    }
    func setupTextField() {
        view.addSubview(titleTextField)
        titleTextField.text = titleText
        titleTextField.frame = CGRect(x: 0 , y: 20 , width: 200, height: 100)

        titleTextField.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 10, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        titleTextField.backgroundColor = .white
    }

    func setupCommentTextView() {
        view.addSubview(commentTextView)
        commentTextView.frame = CGRect(x: 0 , y: 20 , width: 200, height: 200)

        commentTextView.anchor(top: titleTextField.layoutMarginsGuide.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 10), size: .init(width: 200, height: 100))
        commentTextView.backgroundColor = .white
    }

    func setupTopicSubmitButton() {
        view.addSubview(topicSubmitButton)
        topicSubmitButton.anchor(top: commentTextView.layoutMarginsGuide.bottomAnchor, leading: view.layoutMarginsGuide.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 20, left: 10, bottom: 0, right: 0), size: .init(width: 100, height: 30))
        topicSubmitButton.backgroundColor = .green
        topicSubmitButton.setTitle("更新", for: UIControl.State.normal)
        topicSubmitButton.addTarget(self, action: #selector(updateTopic), for: .touchUpInside)
    }

    func setTopicData() {
        db.collection("users").document(userId!).collection("topics").document(topicId!).getDocument { (document, error) in
            if error != nil {
                print("エラーが発生しました。")
                print(error!)
            } else {
                self.titleTextField.text = document?.data()!["title"] as? String
                self.commentTextView.text = document?.data()!["comment"] as? String
            }
        }
    }    
    
    @objc func updateTopic() {
        let title = titleTextField.text ?? ""
        let comment = commentTextView.text ?? ""
        if title == "" || comment == "" {
            self.messageText.text = "空欄はだめだよ"
        } else {
            db.collection("users").document(userId!).collection("topics").document(topicId!).updateData(["title": title, "comment": comment]) { err in
                if let err = err {
                    print(err)
                } else {
                    print("更新しました。")
                    self.messageText.text = "こうしんしました。"
                }
            }
        }
    }
    
    func setupMessageTextField() {
        view.addSubview(messageText)
        messageText.anchor(top: topicSubmitButton.layoutMarginsGuide.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 20))
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

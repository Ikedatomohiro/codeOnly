//
//  SignInViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/29.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    fileprivate let signInStackView = UIStackView()
    fileprivate var emailTextField = UITextField()
    fileprivate var passwordTextField = UITextField()
    fileprivate let signUpButton = UIButton()
    fileprivate let signInButton = UIButton()
    fileprivate let signOutButton = UIButton()
    fileprivate var resultLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        serupTextField()
        setupSignUpButton()
        setupSignInButton()
        setupSignOutButton()
        setResultLabel()

    }
    fileprivate func setupBasic() {
        view.backgroundColor = .cyan
    }
    func serupTextField() {
        view.addSubview(signInStackView)
        signInStackView.axis = .vertical
        signInStackView.spacing = 10.0
        signInStackView.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 100, left: 0, bottom: 0, right: 0), size: .init(width: 300, height: 80))
        
        view.addSubview(emailTextField)
        emailTextField.frame.size.width = 100
        emailTextField.frame.size.height = 30
        emailTextField.borderStyle = .roundedRect
        emailTextField.backgroundColor = .white
        emailTextField.placeholder = "Email"
        signInStackView.addArrangedSubview(emailTextField)

        view.addSubview(passwordTextField)
        passwordTextField.frame.size.width = 100
        passwordTextField.frame.size.height = 30
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.backgroundColor = .white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.placeholder = "パスワード"
        signInStackView.addArrangedSubview(passwordTextField)
    }

    func setupSignUpButton() {
        view.addSubview(signUpButton)
        signUpButton.setTitle("新規登録", for: UIControl.State.normal)
        signUpButton.anchor(top: signInStackView.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top:10, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        signUpButton.backgroundColor = .systemPink
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(createUser), for: .touchUpInside)

    }
    func setupSignInButton() {
        view.addSubview(signInButton)
        signInButton.setTitle("ログイン", for: UIControl.State.normal)
        signInButton.anchor(top: signUpButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top:10, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 40))
        signInButton.backgroundColor = .purple
        signInButton.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(SignIn), for: .touchUpInside)
    }

    func setupSignOutButton() {
        view.addSubview(signOutButton)
        signOutButton.setTitle("ログアウト", for: UIControl.State.normal)
        signOutButton.anchor(top: signInButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top:10, left: 0, bottom: 0, right: 0), size: .init(width: 120, height: 40))
        signOutButton.backgroundColor = .systemBlue
        signOutButton.layer.cornerRadius = 10
        signOutButton.addTarget(self, action: #selector(SignOut), for: .touchUpInside)
    }

    @objc func createUser() {
        print("登録します。")
        if emailTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                guard error == nil else { return }
                guard let uid = authResult?.user.uid else { return }
                Firestore.firestore().collection("users").document(uid).setData([:]) // userの空データを作る
                self.resultLabel.text = "新規登録完了しました"
                print("新規登録成功！")
            }
        }
    }
    @objc func SignIn() {
        print("ログインします。")
        if emailTextField.text != nil && passwordTextField.text != nil {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authResult, error) in
                guard error == nil else { return }
                self.resultLabel.text = "ログインしました"
                print("ログイン成功！")
            }
        }
    }

    @objc func SignOut() {
        print("ログアウトします。")
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.resultLabel.text = "ログアウトしました"
            } catch let error  {
                self.resultLabel.text = "ログアウトに失敗しました"
                print(error)
            }
        }
    }

    func setResultLabel() {
        view.addSubview(resultLabel)
        resultLabel.anchor(top: signOutButton.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 30, left: 0, bottom: 0, right: 0), size: .init(width: 200, height: 30))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

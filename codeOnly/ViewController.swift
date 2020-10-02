//
//  ViewController.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/08/25.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    fileprivate let label = UILabel()
    fileprivate let tableView = UITableView()
    fileprivate let textField = UITextField()
    fileprivate let submitButton = UIButton()
//    fileprivate let titleDB = Database.database().reference().child("titles") // realtime databaseの定義
    fileprivate let db = Firestore.firestore()
    fileprivate var docRef: DocumentReference? = nil
    fileprivate var titlesArray = [String]()
    fileprivate var leftBarButton: UIBarButtonItem!
    fileprivate var rightBarButton: UIBarButtonItem!
    fileprivate var handle:AuthStateDidChangeListenerHandle?
    fileprivate let userId = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupBackgroundImageView()
        setupLabel()
        setupTextField()
        setupButtons()
        setupTableView()
        fetchTitleData()
        
        self.navigationItem.title = "Top Page"

    }

    fileprivate func setupBasic() {
        view.backgroundColor = .white
    }
    fileprivate func setupBackgroundImageView() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "backImage"))
        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    fileprivate func setupLabel() {
        view.addSubview(label)
        label.anchor(top: view.layoutMarginsGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.text = "とりあえずかんたんなやつ"
        label.textColor = .green
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 50, width: view.frame.size.width, height: 20)
    }
    fileprivate func setupTextField() {
        view.addSubview(textField)
        textField.anchor(top: label.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 12, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 30))
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.backgroundColor = .white
        textField.delegate = self
    }
    fileprivate func setupButtons() {
        view.addSubview(submitButton)
        submitButton.anchor(top: textField.bottomAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 32, left: 0, bottom: 0, right: 0), size: .init(width: 150, height: 50))
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.setTitle("ボタンですよ", for: UIControl.State.normal)
        submitButton.addTarget(self, action: #selector(addTitle), for: .touchUpInside)
        
        leftBarButton = UIBarButtonItem(title: "Sign In", style: .plain, target: self, action: #selector(ViewController.tappedLeftBarButton))
        
        rightBarButton = UIBarButtonItem(title: "Stack", style: .plain, target: self, action: #selector(ViewController.tappedRightBarButton))
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    fileprivate func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: submitButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        tableView.backgroundColor = UIColor.init(red: 0.8, green: 0, blue: 0, alpha: 0.1)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.className) // ←
    }
    
    // ボタンをクリックしたときのアクション
    @objc private func addTitle() {
        let inputText = textField.text ?? ""
        // Firestoreにデータを保存する
        if inputText != "" {
            label.text = inputText + "を記録したよ。"
            // 配列に値を追加
            titlesArray.append(inputText)
            // Firestoreにデータを保存する
            db.collection("users").document(userId!).collection("topics").addDocument(data: ["title": inputText]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    print("save OK")
                }
            }
            textField.text = ""
            tableView.reloadData()
        } else {
            label.text = "なにか文字を入れてね。"
        }
    }
    
    // データを取得する
    func fetchTitleData() {
        
//        if userId != "" {
        db.collection("users").document(userId!).collection("topics").getDocuments() {(querySnapshot, err) in
                    print("get data1")

                if let err = err {
                    print("get data2")

                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("get data3")
                        print("\(document.documentID) => \(document.data()["title"]!)")
                        self.titlesArray.append(document.data()["title"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
//        }
        // 新しく更新があったときにデータを取得する
//        db.collection("topics").addSnapshotListener{ querySnapshot, error in
//            guard let documents = querySnapshot?.documents else {
//                print("Error fetching documents: \(error!)")
//                return
//            }
//            let titles = documents.map { $0["title"]! }
//            print("Current cities in CA: \(titles)")
//        }
        
    }
    
    // ボタンをタップしたときのアクション
    @objc func tappedLeftBarButton() {
        let signInPage = SignInViewController()
        self.navigationController?.pushViewController(signInPage, animated: true)
    }

    // ボタンをタップしたときのアクション
    @objc func tappedRightBarButton() {
        let stackVC = StackViewController()
//        present(stackVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(stackVC, animated: true)
    }

    


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className) else { fatalError("improper UITableViewCell")} // ←これはなんだ？？テーブル
        cell.textLabel?.text = titlesArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 次のページにデータを送信する
        let nextViewController = NextViewController(titleText: titlesArray[indexPath.row])
//        nextViewController.modalPresentationStyle = .fullScreen
//        present(nextViewController, animated: true, completion: nil)
//        nextViewController.setup(user: User(id: 0, name: "text"))
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }
    // セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete { // .deleteでもいいみたい
            titlesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            print("削除しました")
        }
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addTitle()
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }

    
}

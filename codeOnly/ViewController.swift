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

// TopicsController
class ViewController: UIViewController {
    fileprivate let label = UILabel()
    fileprivate let tableView = UITableView()
    fileprivate let textField = UITextField()
    fileprivate let submitButton = UIButton()
//    fileprivate let titleDB = Database.database().reference().child("titles") // realtime databaseの定義
    fileprivate let db = Firestore.firestore()
    fileprivate var docRef: DocumentReference? = nil
    fileprivate var titlesArray = [String]()
    fileprivate var titlesDictionary:[Dictionary<String, Any>] = []
    fileprivate var leftBarButton: UIBarButtonItem!
    fileprivate var rightBarButton: UIBarButtonItem!
    fileprivate var handle:AuthStateDidChangeListenerHandle?
    fileprivate var userId = String()
//    fileprivate var topicData = Topic()
    
    fileprivate var topics = [Topic]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBasic()
        setupBackgroundImageView()
        setupLabel()
        setupTextField()
        setupButtons()
        setupTableView()        
        self.navigationItem.title = "Top Page"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logInCheck()
    }
    
    func logInCheck() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if auth.currentUser != nil {
                self.userId = Auth.auth().currentUser!.uid
                self.fetchTitleData()
            } else {
                print("ログインしていません")
                self.titlesArray = []
                self.tableView.reloadData()
            }
        }
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
        tableView.register(TopicCell.self, forCellReuseIdentifier: TopicCell.className) // ←
    }
    
    // ボタンをクリックしたときのアクション
    @objc private func addTitle() {
        let inputText = textField.text ?? ""
        if userId == "" {
            label.text = "ログインしてね。"
        // Firestoreにデータを保存する
        } else if inputText != "" {
            label.text = inputText + "を記録したよ。"
            // 配列に値を追加
            titlesArray.append(inputText)
            // Firestoreにデータを保存する
            db.collection("users").document(userId).collection("topics").addDocument(data: ["title": inputText]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    
                    print("save OK")
                }
            }
            textField.text = ""
            fetchTitleData()
        }   else {
            label.text = "なにか文字を入れてね。"
        }
    }
    
    // データを取得する
    func fetchTitleData() {
        titlesDictionary = []
        print("データ取ります。")
        db.collection("users").document(userId).collection("topics").getDocuments() {(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else { return }
            self.topics = documents.map { (document) ->Topic in
                return Topic(document: document)
            }
            self.tableView.reloadData()
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    self.titlesDictionary.append(["topicID": document.documentID, "title": document.data()["title"] as! String])
                    

                    self.tableView.reloadData()
                }
            }
        }
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
        return topics.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCell.className) as? TopicCell else { fatalError("improper UITableViewCell")} // ←これはなんだ？？テーブル
//        cell.textLabel?.text = titlesArray[indexPath.row] as String
//        cell.textLabel?.text = topics[indexPath.row]["title"] as? String
        cell.setup(topic: topics[indexPath.row])
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
//        var topicData = ["topicID":titlesDictionary[indexPath.row]["topicID"] as? String, "titleText":titlesDictionary[indexPath.row]["title"]! as? String]
//        let nextViewController = NextViewController(coder: topicData)
//        let nextViewController = NextViewController(titleText: titlesArray[indexPath.row])
        // topicIDを送信して、NextViewControllerで内容を取得する。
        let nextViewController = NextViewController(topic: topics[indexPath.row])
        nextViewController.modalPresentationStyle = .fullScreen
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
            // Firestoreのデータを削除
            let targetTopicID = topics[indexPath.row].id
            db.collection("users").document(userId).collection("topics").document(targetTopicID).delete(){ err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    // Firestoreのデータ削除がOKだったら、セルを削除
                    print("Document successfully removed!")
                }
            }
            // topicsの配列削除とtableViewの削除はこの順でないといけない。
            // dbの削除が上にあるのに先に下が呼ばれるようだ。なぜ？？
            self.topics.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
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

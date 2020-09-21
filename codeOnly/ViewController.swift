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
    fileprivate var textArray = [String]()
    fileprivate var leftBarButton: UIBarButtonItem!
    fileprivate var rightBarButton: UIBarButtonItem!
    
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
        submitButton.addTarget(self, action: #selector(addText), for: .touchUpInside)
        
        leftBarButton = UIBarButtonItem(title: "< Previous", style: .plain, target: self, action: #selector(ViewController.tappedLeftBarButton))
        
        rightBarButton = UIBarButtonItem(title: "Next >", style: .plain, target: self, action: #selector(ViewController.tappedRightBarButton))
        
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
    @objc private func addText() {
        let inputText = textField.text ?? ""
        // Firestoreにデータを保存する
        if inputText != "" {
            label.text = inputText + "を記録したよ。"
            // Firestoreにデータを保存する

            // 自動的にランダムな文字列のIDを生成してデータ登録する。
            docRef = db.collection("titles").addDocument(data: ["title": inputText]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(self.docRef!.documentID)")
                }
            }
            textField.text = ""
        } else {
            label.text = "なにか文字を入れてね。"
        }
    }
    
    // データを取得する
    func fetchTitleData() {
        // Firebaseからデータを取得
//        let fetchDataRef = Database.database().reference().child("titles")
        
        // 新しく更新があったときに取得する
//        fetchDataRef.observe(.childAdded, with: { (snapShot) in
//            let snapShotData = snapShot.value as AnyObject
//            let title = snapShotData.value(forKey: "title")
//            self.textArray.append(title as! String)
//            self.tableView.reloadData()
//
//        }, withCancel: nil)
        
        db.collection("titles").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data()["title"]!)")
                    
                    self.textArray.append(document.data()["title"] as! String)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // ボタンをタップしたときのアクション
    @objc func tappedLeftBarButton() {
//        let previousPage = PreviousViewController()
//        self.navigationController?.pushViewController(previousPage, animated: true)
    }

    // ボタンをタップしたときのアクション
    @objc func tappedRightBarButton() {
//        let nextPage = NextViewController.self
//        let nextPage = NextViewController()
//        present(nextPage, animated: true, completion: nil)
//        self.navigationController?.pushViewController(nextPage, animated: true)
    }

    


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in sampleTableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.className) else { fatalError("improper UITableViewCell")} // ←これはなんだ？？テーブル
        cell.textLabel?.text = textArray[indexPath.row]
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
        let nextViewController = NextViewController(titleText: textArray[indexPath.row])
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
            textArray.remove(at: indexPath.row)
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
        textField.resignFirstResponder()
        return true
    }

    
}

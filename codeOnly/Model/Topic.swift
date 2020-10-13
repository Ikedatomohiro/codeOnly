//
//  Topic.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/07.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import Firebase

struct Topic {
    let id: String
    let title: String
    let comment: String
//    var topicData: [Dictionary<String, Any>]
//    var topicDataArray:[String]
    
//    init() {
//        id = ""
//        title = ""
//        comment = ""
////        topicData = []
////        topicDataArray = []
//    }
    
    init(document: QueryDocumentSnapshot) {
        let dictionary = document.data()
        self.id = document.documentID
        self.title = dictionary["title"] as? String ?? ""
        self.comment = dictionary["comment"] as? String ?? ""
    }

    
//    func setTopicData(topicID:String, title:String) {
//        topicData["topicID"] = topicID
//        topicData["title"] = title
//        topicDataArray.append(topicData)
//        return topicDataArray
//    }
}

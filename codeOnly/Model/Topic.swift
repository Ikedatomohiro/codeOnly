//
//  Topic.swift
//  codeOnly
//
//  Created by 池田友宏 on 2020/09/07.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

struct Topic {
    
    let title: String
    let comment: String
    let topicID: String
    var topicData: [Dictionary<String, Any>]
    var topicDataArray:[String]
    
    init() {
        topicID = ""
        title = ""
        comment = ""
        topicData = []
        topicDataArray = []
    }
    
//    func setTopicData(topicID:String, title:String) {
//        topicData["topicID"] = topicID
//        topicData["title"] = title
//        topicDataArray.append(topicData)
//        return topicDataArray
//    }
}

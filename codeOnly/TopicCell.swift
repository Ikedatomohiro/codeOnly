//
//  TopicCell.swift
//  codeOnly
//
//  Created by 杉崎圭 on 2020/10/13.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import UIKit

class TopicCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(topic: Topic) {
        self.textLabel?.text = topic.title
    }
}

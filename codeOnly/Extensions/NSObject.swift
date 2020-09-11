//
//  NSObject.swift
//  codeOnly
//
//  Created by 杉崎圭 on 2020/09/01.
//  Copyright © 2020 Tomohiro Ikeda. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}

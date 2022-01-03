//
//  User.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

class User: SenderType {
    var senderId: String
    var displayName: String
    
    init(
        senderId: String,
        displayName: String
    ) {
        self.senderId = senderId
        self.displayName = displayName
    }
}

extension User: Mapper {
    func mapping() -> [String:Any] {
        let user: [String:Any] =
        [
            "senderId": self.senderId,
            "displayName": self.displayName
        ]
        return user
        
    }
}

extension SenderType {
    func mapping() -> [String:Any] {
        let user: [String:Any] =
        [
            "senderId": self.senderId,
            "displayName": self.displayName
        ]
        return user
    }
}

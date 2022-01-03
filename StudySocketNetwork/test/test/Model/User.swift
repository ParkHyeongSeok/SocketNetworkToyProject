//
//  User.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

class User: SenderType, Mapper {
    typealias DTO = UserDTO
    
    var senderId: String
    var displayName: String
    
    init(
        senderId: String,
        displayName: String
    ) {
        self.senderId = senderId
        self.displayName = displayName
    }
    
    func mapping() -> DTO? {
        return UserDTO(senderId: self.senderId, displayName: self.displayName)
    }
}

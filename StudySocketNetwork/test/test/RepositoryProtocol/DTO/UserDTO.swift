//
//  UserDTO.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import MessageKit

struct UserDTO: Codable {
    var senderId: String
    var displayName: String
}

extension UserDTO {
    func toDomain() -> User {
        return User(senderId: self.senderId, displayName: self.displayName)
    }
}

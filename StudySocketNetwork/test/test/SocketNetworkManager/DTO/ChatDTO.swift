//
//  ChatDTO.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation

struct ChatDTO: Codable {
    var sender: UserDTO
    var messageId: String
    var sentDate: Double
    var content: String
}

extension ChatDTO {
    func toDomain() -> Chat {
        let user = sender.toDomain()
        let date = Date(timeIntervalSince1970: TimeInterval(self.sentDate))
        return Chat(sender: user, messageId: self.messageId, sentDate: date, kind: .text(self.content))
    }
}

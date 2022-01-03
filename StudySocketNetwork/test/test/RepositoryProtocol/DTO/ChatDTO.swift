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
    func toDTO(entity: Chat) -> ChatDTO {
        let userDTO = entity.sender.toDTO(entity: <#T##User#>)
        return ChatDTO(sender: <#T##UserDTO#>, messageId: <#T##String#>, sentDate: <#T##Double#>, content: <#T##String#>)    }
}

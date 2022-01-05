//
//  Chat.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

class Chat: MessageType {
    var sender: SenderType
    var messageId: String
    var roomId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(
        sender: SenderType,
        messageId: String,
        roomId: String,
        sentDate: Date,
        kind: MessageKind
    ) {
        self.sender = sender
        self.messageId = messageId
        self.roomId = roomId
        self.sentDate = sentDate
        self.kind = kind
    }
    
}

extension Chat: Mapper {
    func mapping() -> [String:Any] {
        switch self.kind {
        case .text(let content):
            let chat: [String:Any] =
            [
                "sender": self.sender.mapping(),
                "messageId": self.messageId,
                "roomId": self.roomId,
                "sentDate": Double(self.sentDate.timeIntervalSince1970),
                "content": content
            ]
            return chat
        default:
            return [:]
        }
    }
}

extension Chat: Equatable {
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.messageId == rhs.messageId
    }
}

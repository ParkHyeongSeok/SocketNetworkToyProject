//
//  Chat.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

class Chat: MessageType {
    typealias DTO = ChatDTO
    
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    
    init(
        sender: SenderType,
        messageId: String,
        sentDate: Date,
        kind: MessageKind
    ) {
        self.sender = sender
        self.messageId = messageId
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
                "sentDate": Double(self.sentDate.timeIntervalSince1970),
                "content": content
            ]
            return chat
        default:
            return [:]
        }
    }
}



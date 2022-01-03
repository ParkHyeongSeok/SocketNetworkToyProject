//
//  Chat.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

class Chat: MessageType, Mapper {
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
    
    func mapping() -> DTO? {
        switch self.kind {
        case .text(let content):
            return ChatDTO(sender: self.sender.toDTO(), messageId: self.messageId, sentDate: self.sentDate.timeIntervalSince1970, content: content)
        default:
            return nil
        }
    }
}



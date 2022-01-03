//
//  Room.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import Foundation

class Room: Mapper {
    typealias DTO = RoomDTO
    
    let roomID: String
    var roomTitle: String
    var createDate: Double
    private(set) var chats: [Chat]
    
    init(
        roomID: String,
        roomTitle: String,
        createDate: Double,
        chats: [Chat]
    ) {
        self.roomID = roomID
        self.roomTitle = roomTitle
        self.createDate = createDate
        self.chats = chats
    }
    
    func mapping() -> DTO? {
        return RoomDTO(roomID: self.roomID, roomTitle: self.roomTitle, createDate: self.createDate, chats: self.chats.compactMap { $0.mapping() })
    }
    
    func addChat(chat: Chat) {
        chats.append(chat)
    }
}

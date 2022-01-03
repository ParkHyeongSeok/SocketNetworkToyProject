//
//  RoomDTO.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

struct RoomDTO: Codable {
    var roomID: String
    var roomTitle: String
    var createDate: Double
    var chats: [ChatDTO]
}

extension RoomDTO {
    func toDomain() -> Room {
        let chats = self.chats.map { $0.toDomain() }
        return Room(roomID: self.roomID,
                    roomTitle: self.roomTitle,
                    createDate: self.createDate,
                    chats: chats)
    }
}

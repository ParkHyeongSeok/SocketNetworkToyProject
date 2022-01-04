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
    var participant: [UserDTO]
}

extension RoomDTO {
    func toDomain() -> Room {
        return Room(roomID: self.roomID,
                    roomTitle: self.roomTitle,
                    createDate: Date(timeIntervalSince1970: TimeInterval(self.createDate)),
                    participant: self.participant.map { $0.toDomain() })
    }
}

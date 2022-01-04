//
//  Room.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import Foundation

class Room {
    let roomId: String
    var roomTitle: String
    var createDate: Date
    var participant: [User]
    
    init(
        roomId: String,
        roomTitle: String,
        createDate: Date,
        participant: [User]
    ) {
        self.roomId = roomId
        self.roomTitle = roomTitle
        self.createDate = createDate
        self.participant = participant
    }
    
    func attendRoom(user: User) {
        self.participant.append(user)
    }
    
    func leaveRoom(user: User) {
        if let index = self.participant.firstIndex(where: { $0.senderId == user.senderId }) {
            self.participant.remove(at: index)
        } else {
            print("cannot delete \(user)")
        }
    }
}

extension Room: Mapper {
    func mapping() -> [String:Any] {
        let room: [String:Any] =
        [
            "roomId": self.roomId,
            "roomTitle": self.roomTitle,
            "createDate": Double(self.createDate.timeIntervalSince1970),
            "participant": self.participant.map { $0.mapping() }
        ]
        return room
    }
}

extension Room: Equatable {
    static func == (lhs: Room, rhs: Room) -> Bool {
        return lhs.roomId == rhs.roomId
    }
}

//
//  Room.swift
//  test
//
//  Created by 박형석 on 2021/08/01.
//

import Foundation

class Room {
    let roomID: String
    var roomTitle: String
    var createDate: Date
    var participant: [User]
    
    init(
        roomID: String,
        roomTitle: String,
        createDate: Date,
        participant: [User]
    ) {
        self.roomID = roomID
        self.roomTitle = roomTitle
        self.createDate = createDate
        self.participant = participant
    }
}

extension Room: Mapper {
    func mapping() -> [String:Any] {
        let room: [String:Any] =
        [
            "roomID": self.roomID,
            "roomTitle": self.roomTitle,
            "createDate": Double(self.createDate.timeIntervalSince1970),
            "participant": self.participant.map { $0.mapping() }
        ]
        return room
    }
}

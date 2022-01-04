//
//  ChatViewModel.swift
//  test
//
//  Created by 박형석 on 2022/01/04.
//

import Foundation
import RxCocoa
import RxSwift

class ChatViewModel {
    
    let currentUser: User
    let room: Room
    let socketIOManager: SocketIOManagerType
    init(currentUser: User,
         room: Room,
         socketIOManager: SocketIOManagerType) {
        self.currentUser = currentUser
        self.room = room
        self.socketIOManager = socketIOManager
    }
    
    var chats: Observable<[Chat]> {
        return socketIOManager.allChats.map { $0.filter { $0.roomId == self.room.roomID }}
    }
    
    // input
    func sendMessage(user: User, room: Room, content: String) {
        let newChat = Chat(sender: user, messageId: UUID().uuidString, roomId: room.roomID, sentDate: Date(), kind: .text(content))
        socketIOManager.sendMessage(chat: newChat.mapping())
    }
    
    // output
//    let currentRoomChats: BehaviorRelay<[Chat]> {
//        return Observable.empty()
//    }
    
}

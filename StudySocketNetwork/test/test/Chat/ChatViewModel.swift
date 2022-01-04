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
        return socketIOManager.allChats.map { $0.filter { $0.roomId == self.room.roomId }}
    }
    
    var message: Observable<String?> {
        return socketIOManager.message
    }
    
    var chat: Observable<Chat> {
        return socketIOManager.currentChat
    }
    
    // input
    func sendMessage(newChat: Chat) {
        socketIOManager.sendMessage(chat: newChat.mapping(), room: self.room.mapping())
    }
    
    func leaveRoom() {
        room.leaveRoom(user: self.currentUser)
        socketIOManager.requestLeave(room: self.room.mapping(), user: self.currentUser.mapping())
    }
    
}

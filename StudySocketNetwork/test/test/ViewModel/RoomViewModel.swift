//
//  RoomViewModel.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class RoomViewModel {
    
    private let socketIOManager: SocketIOManagerType
    init(socketIOManager: SocketIOManagerType = MockSocketIOManager.shared) {
        self.socketIOManager = socketIOManager
    }
    
    var currentUser: Driver<User> {
        return socketIOManager.currentUser.asDriver(onErrorJustReturn: DummyData.shared.currentUser)
    }
    
    var rooms: Driver<[Room]> {
        return socketIOManager.allRooms.asDriver(onErrorJustReturn: [])
    }
    
    func createRoom(currentUser: User, roomTitle: String) {
        let newRoom = Room(roomID: UUID().uuidString, roomTitle: roomTitle, createDate: Date(), participant: [currentUser])
        socketIOManager.createRoom(room: newRoom.mapping())
    }
    
    func joinRoom(room: Room, user: User) {
        socketIOManager.joinRoom(room: room.mapping(), user: user.mapping())
    }
    
    func leaveRoom(room: Room, user: User) {
        socketIOManager.leaveRoom(room: room.mapping(), user: user.mapping())
    }
    
}

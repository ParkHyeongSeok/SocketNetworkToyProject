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
    
    let socketIOManager: SocketIOManagerType
    init(socketIOManager: SocketIOManagerType = SocketIOManager.shared) {
        self.socketIOManager = socketIOManager
    }
    
    var currentUser: Driver<User> {
        return socketIOManager.currentUser
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: DummyData.shared.currentUser)
    }
    
    var rooms: Driver<[Room]> {
        return socketIOManager.allRooms
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
    }
    
    func createRoom(newRoom: Room) {
        socketIOManager.requestCreate(room: newRoom.mapping())
    }
    
    func joinRoom(room: Room, user: User) {
        room.attendRoom(user: user)
        socketIOManager.requestJoin(room: room.mapping(), user: user.mapping())
    }
    
    func leaveRoom(room: Room, user: User) {
        socketIOManager.requestLeave(room: room.mapping(), user: user.mapping())
    }
    
}

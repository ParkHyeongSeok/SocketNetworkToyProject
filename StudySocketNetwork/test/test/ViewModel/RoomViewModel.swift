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
    
    private let socketIOManager: SocketIOManagerType = MockSocketIOManager()
    
    var currentUser: Driver<User> {
        return socketIOManager.currentUser.asDriver(onErrorJustReturn: DummyData.shared.currentUser)
    }
    
    var rooms: Driver<[Room]> {
        return socketIOManager.allRooms.asDriver(onErrorJustReturn: [])
    }
    
    func createRoom(roomName: String) {
        
    }
    
    func joinRoom() {
        
    }
    
    func leaveRoom() {
        
    }
    
}

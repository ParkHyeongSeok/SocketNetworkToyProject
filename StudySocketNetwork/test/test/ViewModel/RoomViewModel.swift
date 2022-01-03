//
//  RoomViewModel.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class RoomReactor: Reactor {
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    
    init() {
        self.initialState = State()
    }
    
    let manager = MockSocketIOManager.shared
    
    func createRoom() {
        
    }
    
    func joinRoom() {
        
    }
    
    func leaveRoom() {
        
    }
    
}

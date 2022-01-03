//
//  LoginReactor.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa
import ReactorKit

class LoginReactor: Reactor {
    
    enum Action {

    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    let socketIOManager: SocketIOManagerType
    
    init(socketIOManager: SocketIOManagerType) {
        self.socketIOManager = socketIOManager
        self.initialState = State()
    }

    func signIn(senderID: String) {
        socketIOManager.loginUser(senderID: senderID)
    }
    
    func signOut() {
        //...
    }
    
}

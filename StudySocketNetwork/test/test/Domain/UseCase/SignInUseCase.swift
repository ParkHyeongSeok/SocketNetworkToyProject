//
//  SignInUseCase.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

class SignInUseCase {
    
    let manager = MockSocketIOManager.shared
    
    func signIn(senderID: String) {
        manager.loginUser(senderID: senderID)
    }
    
    func signOut() {
        //...
    }
    
}

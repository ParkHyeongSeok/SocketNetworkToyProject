//
//  SocketIOManagerType.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import RxCocoa

protocol SocketIOManagerType {
    var allRooms: PublishSubject<[Room]> { get set }
    var allChats: PublishSubject<[Chat]> { get set }
    var message: PublishSubject<String?> { get set }
    var currentUser: PublishSubject<User> { get set }
    
    func loginUser(senderID: String)
    // func logoutUser()
    
    func createRoom(room: [String:Any])
    // func deleteRoom(room: [String:Any])
    // func updateRoom(room: [String:Any])
    func joinRoom(room: [String:Any], user: [String:Any])
    func leaveRoom(room: [String:Any], user: [String:Any])
    
    func sendMessage(chat: [String:Any])
}

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
    var allRooms: BehaviorSubject<[Room]> { get set }
    var allChats: BehaviorSubject<[Chat]> { get set }
    var currentUser: BehaviorSubject<User> { get set }
    var currentChat: PublishSubject<Chat> { get set }
    var message: PublishSubject<String?> { get set }
    
    func requestUserData(name: String)
    // func logoutUser()
    
    func requestCreate(room: [String:Any])
    // func deleteRoom(room: [String:Any])
    // func updateRoom(room: [String:Any])
    
    func requestJoin(room: [String:Any], user: [String:Any])
    func requestLeave(room: [String:Any], user: [String:Any])
    
    func sendMessage(chat: [String:Any], room: [String:Any])
}

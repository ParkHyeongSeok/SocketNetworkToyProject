//
//  SocketIOManager.swift
//  test
//
//  Created by 박형석 on 2021/07/29.
//

import Foundation
import RxSwift
import SocketIO

class SocketIOManager: NSObject, SocketIOManagerType {
    
    static let shared = SocketIOManager()
    
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!
    
    var currentUser = BehaviorSubject<User>(value: DummyData.shared.currentUser)
    var allRooms = BehaviorSubject<[Room]>(value: [])
    var allChats = BehaviorSubject<[Chat]>(value: [])
    var currentChat = PublishSubject<Chat>()
    var message = PublishSubject<String?>()
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        
        self.socket.on("currentUser") { data, ack in
            do {
                let userDic = data[0] as? [String:Any] ?? [:]
                let newData = try JSONSerialization.data(withJSONObject: userDic, options: .prettyPrinted)
                let userDTO = try JSONDecoder().decode(UserDTO.self, from: newData)
                self.currentUser.onNext(userDTO.toDomain())
            } catch {
                print("fetch currentUser error: \(error.localizedDescription)")
            }
        }
        
        self.socket.on("rooms") { data, ack in
            do {
                let roomsDic = data[0] as? [[String:Any]] ?? []
                let data = try JSONSerialization.data(withJSONObject: roomsDic, options: .prettyPrinted)
                let roomDTOs = try JSONDecoder().decode([RoomDTO].self, from: data)
                let rooms = roomDTOs.map { $0.toDomain() }
                self.allRooms.onNext(rooms)
            } catch {
                print("fetch rooms error: \(error.localizedDescription)")
            }
        }
        
        self.socket.on("msg") { data, ack in
            let message = data[0] as? String
            self.message.onNext(message)
        }
        
        self.socket.on("roomChats") { data, ack in
            let chatsDic = data[0] as? [[String:Any]] ?? []
            do {
                let newData = try JSONSerialization.data(withJSONObject: chatsDic, options: .prettyPrinted)
                let chatsDTOs = try JSONDecoder().decode([ChatDTO].self, from: newData)
                let chats = chatsDTOs.map { $0.toDomain() }
                self.allChats.onNext(chats)
            } catch {
                print("fetch roomChats error: \(error.localizedDescription)")
            }
        }
        
        self.socket.on("chat") { data, ack in
            let chatDic = data[0] as? [String:Any] ?? [:]
            do {
                let newData = try JSONSerialization.data(withJSONObject: chatDic, options: .prettyPrinted)
                let chatDTO = try JSONDecoder().decode(ChatDTO.self, from: newData)
                self.currentChat.onNext(chatDTO.toDomain())
            } catch {
                print("fetch chat error: \(error.localizedDescription)")
            }
        }
        
    }
    
    func requestUserData(name: String) {
        socket.emit("fetchUser", name)
    }
   
    func requestCreate(room: [String:Any]) {
        socket.emit("createRoom", room)
    }
    
    func requestJoin(room: [String:Any], user: [String:Any]) {
        socket.emit("joinRoom", room, user)
    }
    
    func requestLeave(room: [String:Any], user: [String:Any]) {
        socket.emit("leaveRoom", room, user)
    }
    
    func sendMessage(chat: [String:Any], room: [String:Any]) {
        socket.emit("chat", chat, room)
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
}

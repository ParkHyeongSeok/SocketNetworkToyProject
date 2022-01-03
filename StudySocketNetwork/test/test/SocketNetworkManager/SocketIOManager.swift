//
//  SocketIOManager.swift
//  test
//
//  Created by 박형석 on 2021/07/29.
//

import Foundation
import SocketIO

class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!
    
    var rooms = [Room]() {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roomsUpdate"), object: self.rooms)
            }
        }
    }

    var currentUser: User? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdate"), object: self.currentUser)
            }
        }
    }
    
    var message: String? {
        didSet {
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "message"), object: self.currentUser)
            }
        }
    }
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        
//        socket.on("rooms") { data, ack in
//            self.rooms = []
//            for dt in data[0] as? [[String:Any]] ?? [] {
//
//                let chatDics = dt["chats"] as? [[String:Any]] ?? []
//                let chats = chatDics.map { chatDic in
//                    return Chat(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(chatDic["content"] as? String ?? ""), content: chatDic["content"] as? String ?? "")
//                }
//
//                let newRoom = Room(roomID: dt["roomID"] as? String ?? "", roomTitle: dt["roomTitle"] as? String ?? "", createDate: dt["roomDate"] as? Double ?? 0.0, chats: chats)
//
//                self.rooms.append(newRoom)
//            }
//        }
        
        
        
        socket.on("chat") { data, ack in
            
            let chatDic = data[0] as? [String:Any] ?? [:]
            let userDic = data[1] as? [String:Any] ?? [:]
            let roomDic = data[2] as? [String: Any] ?? [:]
            
            let user = User(senderId: userDic["senderId"] as? String ?? "", displayName: userDic["displayName"] as? String ?? "")
          
            let chat = Chat(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(chatDic["content"] as? String ?? ""))
            
            let room = Room(roomID: roomDic["roomID"] as? String ?? "",
                            roomTitle: roomDic["roomTitle"] as? String ?? "",
                            createDate: roomDic["roomDate"] as? Double ?? 0.0, chats: [])
            
            self.chats.append(chat)
            
        }
        
        socket.on("currentUser") { data, ack in
            let userDic = data[0] as? [String:Any] ?? [:]
            print(data[0])
            let user = User(senderId: userDic["senderId"] as? String ?? "", displayName: userDic["displayName"] as? String ?? "")
            self.currentUser = user
        }
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func sendMessage(room: Room, chat: Chat, user: User) {
        
//        var sender: SenderType
//        var messageId: String
//        var sentDate: Date
//        var kind: MessageKind
//        var content: String
//        unowned var room: Room!
        
        let sentUser: [String:Any] = [
            "senderId": user.senderId,
            "displayName": user.displayName
        ]
        

        
        let myRoom: [String:Any] = [
            "roomID": room.roomID,
            "roomTitle": room.roomTitle,
            "roomDate": room.createDate
        ]
        
        
        
        socket.emit("chat", myChat, myRoom, sentUser)

    }
    
    func createRoom(room: Room) {
        
        let myRoom: [String:Any] = [
            "roomID": room.roomID,
            "roomTitle": room.roomTitle,
            "roomDate": room.createDate
        ]
        
        socket.emit("createRoom", myRoom)
    }
    
    func joinRoom(room: Room, user: User) {
        
        let myRoom: [String:Any] = [
            "roomID": room.roomID,
            "roomTitle": room.roomTitle,
            "roomDate": room.createDate
        ]
        
        
        
        socket.emit("joinRoom", myRoom, user)
    }
    
    func leaveRoom(room: Room, user: User) {
        
        let myRoom: [String:Any] = [
            "roomID": room.roomID,
            "roomTitle": room.roomTitle,
            "roomDate": room.createDate
        ]
        
        let user: [String:Any] = [
            "senderId": user.senderId,
            "displayName": user.displayName
        ]
        
        socket.emit("leaveRoom", myRoom, user)
    }
    
    func loginUser(senderID: String) {
        print(senderID)
        socket.emit("fetchUser", senderID)
    }
    
}

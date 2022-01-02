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
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roomsUpdate"), object: rooms)
        }
    }
    
    var chats = [Chat]() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "chatsUpdate"), object: chats)
        }
    }
    
    var currentUser: User? {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userUpdate"), object: currentUser)
        }
    }
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        
        socket.on("rooms") { data, ack in
            self.rooms = []
            for dt in data[0] as? [[String:Any]] ?? [] {
                let newRoom = Room(roomID: dt["roomID"] as? String ?? "", roomTitle: dt["roomTitle"] as? String ?? "", createDate: dt["roomDate"] as? Double ?? 0.0)
                self.rooms.append(newRoom)
            }
        }
        
        socket.on("msg") { data, ack in
            print(data[0])
        }
        
        socket.on("chat") { data, ack in
            
            let chatDic = data[0] as? [String:Any] ?? [:]
            let userDic = data[1] as? [String:Any] ?? [:]
            
            let user = User(senderId: userDic["userID"] as? String ?? "", displayName: userDic["nickname"] as? String ?? "")
          
            let chat = Chat(sender: user, messageId: UUID().uuidString, sentDate: Date(), kind: .text(chatDic["content"] as? String ?? ""), content: chatDic["content"] as? String ?? "")
            
            self.chats.append(chat)
            
        }
        
        socket.on("currentUser") { data, ack in
            let userDic = data[0] as? [String:Any] ?? [:]
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
        
        let myChat: [String:Any] = [
            "content": chat.content,
            "timestamp": chat.sentDate.timeIntervalSince1970
        ]
        
        let myRoom: [String:Any] = [
            "roomID": room.roomID,
            "roomTitle": room.roomTitle,
            "roomDate": room.createDate
        ]
        
        let sentUser: [String:Any] = [
            "userID": user.senderId,
            "nickname": user.displayName,
            "isConnected": user.isConnected
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
        
        let user: [String:Any] = [
            "userID": user.senderId,
            "nickname": user.displayName,
            "isConnected": user.isConnected
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
            "userID": user.senderId,
            "nickname": user.displayName,
            "isConnected": user.isConnected
        ]
        
        socket.emit("leaveRoom", myRoom, user)
    }
    
    func loginUser(senderID: String) {
        socket.emit("fetchUser", senderID)
    }
    
}

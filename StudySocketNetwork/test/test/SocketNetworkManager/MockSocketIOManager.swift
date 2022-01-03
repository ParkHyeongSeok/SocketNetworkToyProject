//
//  MockSocketIOManager.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import RxSwift
import SocketIO

class MockSocketIOManager: NSObject, SocketIOManagerType {
    static let shared = MockSocketIOManager()
    
    private var manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    private var socket: SocketIOClient!
    
    var allRooms = PublishSubject<[Room]>()
    var currentUser = PublishSubject<User>()
    var message = PublishSubject<String?>()
    
    override init() {
        super.init()
        self.socket = manager.defaultSocket
        
        // Rooms listener
        socket.on("rooms") { data, ack in
            do {
                let roomsDic = data[0] as? [[String:Any]] ?? []
                let data = try JSONSerialization.data(withJSONObject: roomsDic, options: .prettyPrinted)
                let roomDTOs = try JSONDecoder().decode([RoomDTO].self, from: data)
                let rooms = roomDTOs.map { $0.toDomain() }
                self.allRooms.onNext(rooms)
            } catch {
                print("⛔️ fetch all rooms error : \(error.localizedDescription)")
            }
        }
        
        // message listener
        socket.on("msg") { data, ack in
            let message = data[0] as? String
            self.message.onNext(message)
        }
        
        // user listener
        socket.on("currentUser") { data, ack in
            do {
                let userDic = data[0] as? [String:Any] ?? [:]
                let newData = try JSONSerialization.data(withJSONObject: userDic, options: .prettyPrinted)
                let userDTO = try JSONDecoder().decode(UserDTO.self, from: newData)
                self.currentUser.onNext(userDTO.toDomain())
            } catch {
                print("⛔️ fetch user error : \(error.localizedDescription)")
            }
        }
        
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func loginUser(senderID: String) {
        socket.emit("fetchUser", senderID)
    }
    
    func createRoom(room: [String:Any]) {
        socket.emit("createRoom", room)
    }
    
    func joinRoom(room: [String:Any], user: [String:Any]) {
        socket.emit("joinRoom", room, user)
    }
    
    func leaveRoom(room: [String:Any], user: [String:Any]) {
        socket.emit("leaveRoom", room, user)
    }
}
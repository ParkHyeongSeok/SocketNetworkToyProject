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
    var currentUser: PublishSubject<User> { get set }
    var message: PublishSubject<String?> { get set }
}

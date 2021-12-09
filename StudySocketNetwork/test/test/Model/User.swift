//
//  User.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation
import MessageKit

struct User: SenderType {
    var senderId: String
    var displayName: String
    var isConnected: Bool = false
}

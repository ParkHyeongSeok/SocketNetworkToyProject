//
//  DummyData.swift
//  test
//
//  Created by 박형석 on 2021/07/31.
//

import Foundation

class DummyData {
    static let shared = DummyData()
    
    let currentUser = User(senderId: "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80", displayName: "하잇")

}

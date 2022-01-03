//
//  Mapper.swift
//  test
//
//  Created by 박형석 on 2022/01/03.
//

import Foundation
import MessageKit

protocol Mapper {
    associatedtype DTO
    func mapping() -> DTO?
}

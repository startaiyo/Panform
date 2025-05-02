//
//  UserModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import Foundation

typealias UserID = UUID

struct UserModel {
    let id: UserID
    let name: String
    let email: String
    let description: String
    let avatarURL: URL
}

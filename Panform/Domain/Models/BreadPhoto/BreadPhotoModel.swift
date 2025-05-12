//
//  BreadPhotoModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import Foundation

typealias BreadPhotoID = UUID

struct BreadPhotoModel: Identifiable {
    let id: BreadPhotoID
    let breadID: BreadID
    let userID: UserID
    let imageURL: URL
}

extension BreadPhotoModel {
    static func stub() -> BreadPhotoModel {
        return .init(id: UUID(),
                     breadID: UUID(),
                     userID: UUID(),
                     imageURL: URL(string: "https://placehold.jp/150x150.png")!)
    }
}

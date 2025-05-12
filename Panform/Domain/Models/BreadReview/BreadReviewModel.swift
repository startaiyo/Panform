//
//  BreadReviewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import Foundation

typealias BreadReviewID = UUID

struct BreadReviewModel {
    let id: BreadReviewID
    let breadID: BreadID
    let comment: String
    let userID: UserID
    let rate: Float
}

extension BreadReviewModel {
    static func stub() -> BreadReviewModel {
        return .init(id: UUID(),
                     breadID: UUID(),
                     comment: "comment",
                     userID: UUID(),
                     rate: Float((Float.random(in: 1.0...5.0) * 10).rounded() / 10))
    }
}

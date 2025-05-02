//
//  BreadModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import Foundation

typealias BreadID = UUID

struct BreadModel: Identifiable {
    let id: BreadID
    let name: String
    let price: Int
    let bakeryID: BakeryID
}

extension BreadModel {
    static func stub() -> BreadModel {
        return .init(id: UUID(),
                     name: "name",
                     price: 100,
                     bakeryID: UUID())
    }
}

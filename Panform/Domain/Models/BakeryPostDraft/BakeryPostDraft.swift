//
//  BakeryPostDraft.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/27.
//

import SwiftData
import UIKit

@Model
class BakeryPostDraft: Identifiable {
    var id: UUID
    var placeID: String
    var breadID: BreadID?
    var breadName: String
    var price: Int
    var score: Float
    var comment: String
    var draftImages: [BakeryPostDraftImage]
    var uid: String

    init(id: UUID, placeID: String, breadID: BreadID?, breadName: String, score: Float, price: Int, comment: String, draftImages: [BakeryPostDraftImage], uid: String) {
        self.id = id
        self.placeID = placeID
        self.breadID = breadID
        self.breadName = breadName
        self.score = score
        self.comment = comment
        self.draftImages = draftImages
        self.price = price
        self.uid = uid
    }
}

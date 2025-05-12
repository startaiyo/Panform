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
    var bakeryID: BakeryID
    var breadID: BreadID?
    var breadName: String
    var price: Int
    var score: Float
    var comment: String
    var draftImages: [BakeryPostDraftImage]
    var uid: String

    init(id: UUID, bakeryID: BakeryID, breadID: BreadID?, breadName: String, score: Float, price: Int, comment: String, draftImages: [BakeryPostDraftImage], uid: String) {
        self.id = id
        self.bakeryID = bakeryID
        self.breadID = breadID
        self.breadName = breadName
        self.score = score
        self.comment = comment
        self.draftImages = draftImages
        self.price = price
        self.uid = uid
    }
}

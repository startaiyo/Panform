//
//  SavedBread.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/07.
//

import Foundation
import SwiftData

typealias SavedBreadID = UUID

@Model
class SavedBread: Identifiable {
    var id: SavedBreadID
    var breadID: BreadID
    var comment: String
    var uid: String

    init(id: SavedBreadID,
         breadID: BreadID,
         comment: String,
         uid: String) {
        self.id = id
        self.breadID = breadID
        self.comment = comment
        self.uid = uid
    }
}

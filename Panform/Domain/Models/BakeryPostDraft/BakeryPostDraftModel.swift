//
//  BakeryPostDraftModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/27.
//

import SwiftData
import UIKit

@Model
class BakeryPostDraftModel: Identifiable {
    var id: UUID
    var bakeryID: BakeryID
    var breadName: String
    var score: Float
    var comment: String
    var selectedPhotos: [Data]

    init(id: UUID, bakeryID: BakeryID, breadName: String, score: Float, comment: String, selectedPhotos: [UIImage]) {
        self.id = id
        self.bakeryID = bakeryID
        self.breadName = breadName
        self.score = score
        self.comment = comment
        self.selectedPhotos = selectedPhotos.compactMap { $0.jpegData(compressionQuality: 0.8) }
    }

    var selectedImages: [UIImage] {
        selectedPhotos.compactMap { UIImage(data: $0) }
    }
}

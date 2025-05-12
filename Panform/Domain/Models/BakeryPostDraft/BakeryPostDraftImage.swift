//
//  BakeryPostDraftImage.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/09.
//

import SwiftData
import UIKit

@Model
class BakeryPostDraftImage: Identifiable {
    var id: UUID
    var imageData: Data

    init(id: UUID,
         imageData: Data) {
        self.id = id
        self.imageData = imageData
    }
}

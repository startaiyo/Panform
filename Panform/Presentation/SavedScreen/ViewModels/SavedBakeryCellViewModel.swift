//
//  SavedBakeryCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/07.
//

import SwiftUI

protocol SavedBakeryCellViewModelProtocol: ObservableObject {
    
}

final class SavedBakeryCellViewModel: SavedBakeryCellViewModelProtocol {
    @Published var bakery: BakeryModel
    @Published var breads: [BreadModel]
    @Published var breadReviews: [BreadReviewModel]
    @Published var breadPhotos: [BreadPhotoModel]

    init(bakery: BakeryModel,
         breads: [BreadModel],
         breadReviews: [BreadReviewModel],
         breadPhotos: [BreadPhotoModel]) {
        self.bakery = bakery
        self.breads = breads
        self.breadReviews = breadReviews
        self.breadPhotos = breadPhotos
    }
}

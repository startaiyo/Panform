//
//  SavedViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/07.
//

import SwiftUI

protocol SavedViewModelProtocol: ObservableObject {
    
}

final class SavedViewModel: SavedViewModelProtocol {
    @Published var bakeries: [BakeryModel]
    @Published var breads: [BreadModel]
    @Published var breadReviews: [BreadReviewModel]
    @Published var breadPhotos: [BreadPhotoModel]

    init(bakeries: [BakeryModel],
         breads: [BreadModel],
         breadReviews: [BreadReviewModel],
         breadPhotos: [BreadPhotoModel]) {
        self.bakeries = bakeries
        self.breads = breads
        self.breadReviews = breadReviews
        self.breadPhotos = breadPhotos
    }
}

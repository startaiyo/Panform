//
//  SavedBakeryCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/07.
//

import SwiftUI

protocol SavedBakeryCellViewModelProtocol: ObservableObject {
    
}

final class SavedBakeryCellViewModel: SavedBakeryCellViewModelProtocol, Identifiable {
    @Published var bakery: BakeryModel
    @Published var breads: [BreadModel]
    @Published var breadReviews: [BreadReviewModel]
    @Published var breadPhotos: [BreadPhotoModel]
    let didRequestToSavedBakeryScreen: (BakeryID) -> Void

    init(bakery: BakeryModel,
         breads: [BreadModel],
         breadReviews: [BreadReviewModel],
         breadPhotos: [BreadPhotoModel],
         didRequestToSavedBakeryScreen: @escaping (BakeryID) -> Void) {
        self.bakery = bakery
        self.breads = breads
        self.breadReviews = breadReviews
        self.breadPhotos = breadPhotos
        self.didRequestToSavedBakeryScreen = didRequestToSavedBakeryScreen
    }
}

// MARK: - Inputs
extension SavedBakeryCellViewModel {
    func showSavedBakeryScreen() {
        didRequestToSavedBakeryScreen(bakery.id)
    }
}

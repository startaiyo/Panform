//
//  BakeryDetailViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol BakeryDetailViewModelProtocol: ObservableObject {
    var bakery: BakeryModel { get }
}

final class BakeryDetailViewModel: BakeryDetailViewModelProtocol {
    @Published var bakery: BakeryModel
    @Published var breads: [BreadModel]
    @Published var breadReviews: [BreadReviewModel]
    @Published var breadPhotos: [BreadPhotoModel]
    private let didRequestToShowBakeryPost: () -> Void

    init(bakery: BakeryModel,
         breads: [BreadModel],
         breadReviews: [BreadReviewModel],
         breadPhotos: [BreadPhotoModel],
         didRequestToShowBakeryPost: @escaping () -> Void) {
        self.bakery = bakery
        self.breads = breads
        self.breadReviews = breadReviews
        self.breadPhotos = breadPhotos
        self.didRequestToShowBakeryPost = didRequestToShowBakeryPost
    }
}

// MARK: Outputs
extension BakeryDetailViewModel {
    var averageBreadRating: Double {
        let rates = breadReviews.map { Double($0.rate) }
        return rates.isEmpty ? 0.0 : rates.reduce(0.0, +) / Double(rates.count)
    }
}

// MARK: Inputs
extension BakeryDetailViewModel {
    func showBakeryPostScreen() {
        didRequestToShowBakeryPost()
    }
}

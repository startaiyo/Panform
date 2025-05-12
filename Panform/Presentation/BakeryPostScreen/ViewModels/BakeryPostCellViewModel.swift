//
//  BakeryPostCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftUI

protocol BakeryPostCellViewModelProtocol: ObservableObject {
    
}

final class BakeryPostCellViewModel: BakeryPostCellViewModelProtocol, Identifiable  {
    let bread: BreadModel?
    let reviews: [BreadReviewModel]
    let photos: [BreadPhotoModel]
    let didRequestToAddReview: ((BreadModel) -> Void)?

    init(bread: BreadModel?, reviews: [BreadReviewModel], photos: [BreadPhotoModel], didRequestToAddReview: ((BreadModel) -> Void)?) {
        self.bread = bread
        self.reviews = reviews
        self.photos = photos
        self.didRequestToAddReview = didRequestToAddReview
    }
}

// MARK: - Inputs
extension BakeryPostCellViewModel {
    func addReview(of breadModel: BreadModel) {
        didRequestToAddReview?(breadModel)
    }
}

// MARK: - Outputs
extension BakeryPostCellViewModel {
    var averageRating: Double {
        let rates = reviews.map { Double($0.rate) }
        return rates.isEmpty ? 0.0 : rates.reduce(0.0, +) / Double(rates.count)
    }

    var reviewComment: String? {
        reviews.first?.comment
    }
}

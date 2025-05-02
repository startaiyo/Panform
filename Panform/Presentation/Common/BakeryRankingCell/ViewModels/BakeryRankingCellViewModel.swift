//
//  BakeryRankingCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/09.
//

import SwiftUI

protocol BakeryRankingCellViewModelProtocol: ObservableObject {
    var bread: BreadModel { get }
    var averageRating: Float { get }
}

final class BakeryRankingCellViewModel: BakeryRankingCellViewModelProtocol {
    let bread: BreadModel
    let reviews: [BreadReviewModel]

    init(bread: BreadModel,
         reviews: [BreadReviewModel]) {
        self.bread = bread
        self.reviews = reviews
    }

    var averageRating: Float {
        let totalRating = reviews.reduce(0, { $0 + $1.rate })
        let averageRating = totalRating / Float(reviews.count)
        return averageRating
    }
}

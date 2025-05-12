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

final class BakeryRankingCellViewModel: BakeryRankingCellViewModelProtocol, Identifiable {
    let bread: BreadModel
    let reviews: [BreadReviewModel]
    private let authNetworkService: AuthNetworkServiceProtocol
    private let bakeryStorageService: BakeryStorageServiceProtocol
    @Published var savedBread: SavedBread?
    @Published var isSaved: Bool
    @Published var comment = ""

    init(bread: BreadModel,
         reviews: [BreadReviewModel],
         authNetworkService: AuthNetworkServiceProtocol,
         bakeryStorageService: BakeryStorageServiceProtocol) {
        self.bread = bread
        self.reviews = reviews
        self.authNetworkService = authNetworkService
        self.bakeryStorageService = bakeryStorageService
        let savedBread = bakeryStorageService.getSavedBreads().first(where: { $0.breadID == bread.id })
        self.savedBread = savedBread
        self.isSaved = savedBread != nil
        if let comment = savedBread?.comment {
            self.comment = comment
        }
    }

    deinit {
        savedBread?.comment = comment
        bakeryStorageService.updateSavedBread()
    }

    var averageRating: Float {
        let totalRating = reviews.reduce(0, { $0 + $1.rate })
        let averageRating = totalRating / Float(reviews.count)
        return averageRating
    }
}

// MARK: - Inputs
extension BakeryRankingCellViewModel {
    func saveButtonTapped() {
        savedBread = bakeryStorageService.getSavedBreads().first(where: { $0.breadID == bread.id })
        if let savedBread {
            bakeryStorageService.unsaveBread(savedBread)
            isSaved = false
        } else {
            guard let uid = authNetworkService.currentUser?.uid else { return }
            let savedBread = SavedBread(id: UUID(),
                                        breadID: bread.id,
                                        comment: "",
                                        uid: uid)
            self.savedBread = savedBread
            bakeryStorageService.saveBread(savedBread)
            isSaved = true
        }
    }
}

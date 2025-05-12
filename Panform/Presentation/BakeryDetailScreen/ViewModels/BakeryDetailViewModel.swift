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
    @Published var breads: [BreadModel] = []
    @Published var breadReviews: [BreadReviewModel] = []
    @Published var breadPhotos: [BreadPhotoModel] = []
    private let apolloClient: GraphQLClient
    private let authNetworkService: AuthNetworkServiceProtocol
    private let bakeryStorageService: BakeryStorageService
    private let didRequestToShowBakeryPost: () -> Void

    init(bakery: BakeryModel,
         apolloClient: GraphQLClient,
         authNetworkService: AuthNetworkServiceProtocol,
         bakeryStorageService: BakeryStorageService,
         didRequestToShowBakeryPost: @escaping () -> Void) {
        self.bakery = bakery
        self.apolloClient = apolloClient
        self.authNetworkService = authNetworkService
        self.bakeryStorageService = bakeryStorageService
        self.didRequestToShowBakeryPost = didRequestToShowBakeryPost
        getBakeryData()
    }
}

// MARK: - Private functions
private extension BakeryDetailViewModel {
    func getBakeryData() {
        apolloClient.apollo.fetch(query: Panform.GetBakeryDataQuery(bakeryID: bakery.id.uuidString)) { [weak self] result in
            guard let self,
                  let bakery = try? result.get().data?.bakeries.first
            else {
                return
            }
            bakery.breads.forEach { bread in
                if let breadID = UUID(uuidString: bread.id) {
                    self.breads.append(.init(id: breadID,
                                             name: bread.name,
                                             price: bread.price,
                                             bakeryID: self.bakery.id))
                    bread.breadPhotos.forEach {
                        if let breadPhotoID = UUID(uuidString: $0.id),
                           let userID = UUID(uuidString: $0.userId),
                           let imageURL = URL(string: $0.imageUrl) {
                            self.breadPhotos.append(.init(id: breadPhotoID,
                                                          breadID: breadID,
                                                          userID: userID,
                                                          imageURL: imageURL))
                        }
                    }
                    bread.breadReviews.forEach {
                        if let breadReviewID = UUID(uuidString: $0.id),
                           let userID = UUID(uuidString: $0.userId),
                           let rate = Float($0.rate) {
                            self.breadReviews.append(.init(id: breadReviewID,
                                                           breadID: breadID,
                                                           comment: $0.comment,
                                                           userID: userID,
                                                           rate: rate))
                        }
                    }
                }
            }
        }
    }
}

// MARK: Outputs
extension BakeryDetailViewModel {
    var averageBreadRating: Double {
        let rates = breadReviews.map { Double($0.rate) }
        return rates.isEmpty ? 0.0 : rates.reduce(0.0, +) / Double(rates.count)
    }

    var bakeryRankingCellViewModels: [BakeryRankingCellViewModel] {
        return breads.map { bread in
            return .init(bread: bread,
                         reviews: breadReviews.filter { $0.breadID == bread.id },
                         authNetworkService: authNetworkService,
                         bakeryStorageService: bakeryStorageService) }
    }
}

// MARK: Inputs
extension BakeryDetailViewModel {
    func showBakeryPostScreen() {
        didRequestToShowBakeryPost()
    }
}

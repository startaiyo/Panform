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
    @Published var savedBreads: [SavedBread] = []
    @Published var bakeries: [BakeryModel] = []
    @Published var breads: [BreadModel] = []
    @Published var breadReviews: [BreadReviewModel] = []
    @Published var breadPhotos: [BreadPhotoModel] = []
    private let bakeryStorageService: BakeryStorageServiceProtocol
    private let apolloClient: GraphQLClient
    private let didRequestToSavedBakeryScreen: (BakeryID) -> Void

    init(apolloClient: GraphQLClient,
         bakeryStorageService: BakeryStorageServiceProtocol,
         didRequestToSavedBakeryScreen: @escaping (BakeryID) -> Void) {
        self.apolloClient = apolloClient
        self.bakeryStorageService = bakeryStorageService
        self.didRequestToSavedBakeryScreen = didRequestToSavedBakeryScreen
        getBakeriesInfoFromSavedBreads()
    }
}

// MARK: - Private functions
private extension SavedViewModel {
    func getBakeriesInfoFromSavedBreads() {
        bakeries = []
        breads = []
        breadPhotos = []
        breadReviews = []
        savedBreads = bakeryStorageService.getSavedBreads()
        let savedBreadIds = savedBreads.map { $0.breadID.uuidString }
        apolloClient.apollo.fetch(query: Panform.GetSavedBakeriesInfoQuery(breadIds: .some(savedBreadIds))) { result in
            let data = try? result.get().data?.bakeries
            data?.forEach {
                guard let id = UUID(uuidString: $0.id),
                      let openAt = TimeOnly(hour: $0.openAt, minute: 0),
                      let closeAt = TimeOnly(hour: $0.closeAt, minute: 0),
                      let latitude = Double($0.latitude),
                      let longitude = Double($0.longitude) else {
                    return
                }
                self.bakeries.append(BakeryModel(id: id,
                                                 name: $0.name,
                                                 memo: "",
                                                 openAt: openAt,
                                                 closeAt: closeAt,
                                                 openingDays: $0.openingDays.compactMap { day in
                        .init(rawValue: day)
                },
                                                 location: .init(latitude: latitude,
                                                                 longitude: longitude)))
                let bakery = $0
                bakery.breads.forEach { bread in
                    if let breadID = UUID(uuidString: bread.id),
                       let bakeryID = UUID(uuidString: bakery.id) {
                        self.breads.append(.init(id: breadID,
                                                 name: bread.name,
                                                 price: bread.price,
                                                 bakeryID: bakeryID))
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
}

// MARK: - Inputs
extension SavedViewModel {
    func reload() {
        getBakeriesInfoFromSavedBreads()
    }
}

// MARK: - Outputs
extension SavedViewModel {
    var savedBakeryCellViewModels: [SavedBakeryCellViewModel] {
        bakeries.map { bakery in
            let firstBread = breads.first(where: { $0.bakeryID == bakery.id })
            return SavedBakeryCellViewModel(
                bakery: bakery,
                breads: breads.filter { $0.bakeryID == bakery.id },
                breadReviews: breadReviews.filter { $0.breadID == firstBread?.id },
                breadPhotos: breadPhotos.filter { $0.breadID == firstBread?.id },
                didRequestToSavedBakeryScreen: { self.didRequestToSavedBakeryScreen($0) }
            )
        }
    }
}

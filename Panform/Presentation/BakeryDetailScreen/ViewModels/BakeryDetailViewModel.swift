//
//  BakeryDetailViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol BakeryDetailViewModelProtocol: ObservableObject {
    var bakery: BakeryModel? { get }
}

final class BakeryDetailViewModel: BakeryDetailViewModelProtocol {
    @Published var bakery: BakeryModel?
    @Published var breads: [BreadModel] = []
    @Published var breadReviews: [BreadReviewModel] = []
    @Published var breadPhotos: [BreadPhotoModel] = []
    let place: Place
    private let apolloClient: GraphQLClient
    private let authNetworkService: AuthNetworkServiceProtocol
    private let bakeryStorageService: BakeryStorageService
    private let didRequestToShowBakeryPost: () -> Void

    init(bakery: BakeryModel?,
         place: Place,
         apolloClient: GraphQLClient,
         authNetworkService: AuthNetworkServiceProtocol,
         bakeryStorageService: BakeryStorageService,
         didRequestToShowBakeryPost: @escaping () -> Void) {
        self.bakery = bakery
        self.place = place
        self.apolloClient = apolloClient
        self.authNetworkService = authNetworkService
        self.bakeryStorageService = bakeryStorageService
        self.didRequestToShowBakeryPost = didRequestToShowBakeryPost
    }
}

// MARK: - Private functions
private extension BakeryDetailViewModel {
    func getBakeryData() {
        Task { @MainActor in
            guard let bakery = try await getBakeryInfo(placeID: place.placeID) else { return }
            breads = []
            breadReviews = []
            breadPhotos = []
            apolloClient.apollo.fetch(query: Panform.GetBakeryDataQuery(bakeryID: bakery.id.uuidString),
                                      cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] result in
                guard let self,
                      let bakeryData = try? result.get().data?.bakeries.first
                else {
                    return
                }
                if let bakeryID = UUID(uuidString: bakeryData.id),
                   let latitude = Double(bakeryData.latitude),
                   let longitude = Double(bakeryData.longitude) {
                    self.bakery = .init(id: bakeryID,
                                        name: bakeryData.name,
                                        openAt: bakeryData.openAt != nil ? .init(hour: bakeryData.openAt!,
                                                                                 minute: 0) : nil,
                                        closeAt: bakeryData.closeAt != nil ? .init(hour: bakeryData.closeAt!,
                                                                                   minute: 0) : nil,
                                        openingDays: bakeryData.openingDays?.compactMap { WeekDay(rawValue: $0) },
                                        location: .init(latitude: latitude,
                                                        longitude: longitude),
                                        placeID: bakeryData.placeId)
                }
                bakeryData.breads.forEach { bread in
                    if let breadID = UUID(uuidString: bread.id) {
                        self.breads.append(.init(id: breadID,
                                                 name: bread.name,
                                                 price: bread.price,
                                                 bakeryID: bakery.id))
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

    func getBakeryInfo(placeID: String) async throws -> BakeryModel? {
        return try await withCheckedThrowingContinuation { continuation in
            apolloClient.apollo.fetch(query: Panform.GetBakeryByPlaceIdQuery(placeId: placeID),
                                      cachePolicy: .fetchIgnoringCacheCompletely) { result in
                switch result {
                case .success(let graphQLResult):
                    guard let bakeryData = graphQLResult.data?.bakeries.first else {
                        continuation.resume(returning: nil)
                        return
                    }
                    if let bakeryID = UUID(uuidString: bakeryData.id),
                       let latitude = Double(bakeryData.latitude),
                       let longitude = Double(bakeryData.longitude) {
                        let bakery = BakeryModel(id: bakeryID,
                                                name: bakeryData.name,
                                                openAt: bakeryData.openAt != nil ? .init(hour: bakeryData.openAt!,
                                                                                         minute: 0) : nil,
                                                closeAt: bakeryData.closeAt != nil ? .init(hour: bakeryData.closeAt!,
                                                                                           minute: 0) : nil,
                                                openingDays: bakeryData.openingDays?.compactMap { WeekDay(rawValue: $0) },
                                                location: .init(latitude: latitude,
                                                                longitude: longitude),
                                                placeID: bakeryData.placeId)
                        continuation.resume(returning: bakery)
                    } else {
                        continuation.resume(returning: nil)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
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
    func reload() {
        getBakeryData()
    }

    func showBakeryPostScreen() {
        didRequestToShowBakeryPost()
    }

    func updateBakeryData(open: Date,
                          close: Date,
                          openingDays: [WeekDay]) {
        guard let bakeryIDString = bakery?.id else { return }
        apolloClient.apollo.perform(mutation: Panform.UpdateBakeryMutation(id: bakeryIDString.uuidString,
                                                                           openingDays: .some(openingDays.map { $0.rawValue }),
                                                                           openAt: TimeOnly(from: open) != nil ? .some(TimeOnly(from: open)!.hour) : .none,
                                                                           closeAt: TimeOnly(from: close) != nil ? .some(TimeOnly(from: close)!.hour) : .none)) {[weak self] _ in
            self?.getBakeryData()
        }
    }
}

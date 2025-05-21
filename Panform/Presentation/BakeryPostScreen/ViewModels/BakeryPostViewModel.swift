//
//  BakeryPostViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftData
import SwiftUI

protocol BakeryPostViewModelProtocol: ObservableObject {

}

final class BakeryPostViewModel: BakeryPostViewModelProtocol {
    @Published var breads: [BreadModel] = []
    @Published var breadReviews: [BreadReviewModel] = []
    @Published var breadPhotos: [BreadPhotoModel] = []
    @Published var bakeryPostDrafts: [BakeryPostDraft] = []
    @Published var shouldShowLoading = false

    private let apolloClient: GraphQLClient
    private var place: Place
    private var bakeryID: BakeryID?
    let authNetworkService: AuthNetworkServiceProtocol
    let bakeryStorageService: BakeryStorageServiceProtocol
    let bakeryNetworkService: BakeryNetworkServiceProtocol

    init(apolloClient: GraphQLClient,
         bakery: BakeryModel?,
         place: Place,
         authNetworkService: AuthNetworkServiceProtocol,
         bakeryStorageService: BakeryStorageServiceProtocol,
         bakeryNetworkService: BakeryNetworkServiceProtocol) {
        self.apolloClient = apolloClient
        self.authNetworkService = authNetworkService
        self.bakeryStorageService = bakeryStorageService
        self.bakeryNetworkService = bakeryNetworkService
        self.place = place
        bakeryID = bakery?.id
        getBakeryData(bakeryID: bakeryID)
        reloadDrafts()
    }

    func addNewPost(for bread: BreadModel?) {
        guard let uid = authNetworkService.currentUser?.uid
        else {
            return
        }
        let newDraft = BakeryPostDraft(id: UUID(),
                                       placeID: place.placeID,
                                       breadID: bread?.id,
                                       breadName: bread?.name ?? "",
                                       score: 1.0,
                                       price: bread?.price ?? 0,
                                       comment: "",
                                       draftImages: [],
                                       uid: uid)
        bakeryStorageService.insertBakeryPostDraft(newDraft)
        reloadDrafts()
        getBakeryData(bakeryID: bakeryID)
    }
}

// MARK: - Private functions
private extension BakeryPostViewModel {
    func getBakeryData(bakeryID: BakeryID?) {
        breads = []
        breadPhotos = []
        breadReviews = []
        guard let bakeryID else { return }
        apolloClient.apollo.fetch(query: Panform.GetBakeryDataQuery(bakeryID: bakeryID.uuidString),
                                  cachePolicy: .fetchIgnoringCacheCompletely) { [weak self] result in
            guard let self,
                  let bakeryData = try? result.get().data?.bakeries.first
            else {
                return
            }
            bakeryData.breads.forEach { bread in
                if let breadID = UUID(uuidString: bread.id) {
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

    func reloadDrafts() {
        bakeryPostDrafts = bakeryStorageService.fetchBakeryPostDrafts(of: place.placeID)
    }

    func postReviews(of bakeryPostDraft: BakeryPostDraft) {
        shouldShowLoading = true
        Task { [weak self] in
            guard let self else { return }
            if bakeryID == nil {
                bakeryID = try await insertBakery(of: place)
            }

            guard let userID = authNetworkService.currentPanformUserID else { return }
            let imageURLs = try await uploadImage(of: bakeryPostDraft)
            let imageInputs = imageURLs.map { imageURL in Panform.BreadPhotos_insert_input(imageUrl: .some(imageURL.absoluteString), userId: .some(userID.uuidString)) }
            let breadID: GraphQLNullable<Panform.Uuid> = bakeryPostDraft.breadID?.uuidString ?? .some(UUID().uuidString)

            let mutation = Panform.UpsertBreadPostMutation(
                breadID: breadID,
                bakeryID: bakeryID!.uuidString,
                name: bakeryPostDraft.breadName,
                price: bakeryPostDraft.price,
                comment: bakeryPostDraft.comment,
                rate: String(bakeryPostDraft.score),
                userId: userID.uuidString,
                imageUrls: imageInputs
            )

            apolloClient.apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let idString = graphQLResult.data?.insert_breads_one?.id,
                       let id = UUID(uuidString: idString) {
                        print(id.uuidString + "inserted")
                        self.bakeryStorageService.deleteBakeryPostDraft(bakeryPostDraft)
                        self.reloadDrafts()
                        self.getBakeryData(bakeryID: self.bakeryID!)
                    } else if let errors = graphQLResult.errors {
                        print(errors)
                    }
                case .failure(let error):
                    print(error)
                }
                self.shouldShowLoading = false
            }
        }
    }

    func insertBakery(of place: Place) async throws -> BakeryID {
        return try await withCheckedThrowingContinuation { continuation in
            guard let latitude = place.geometry?.location.lat,
                  let longitude = place.geometry?.location.lng
            else {
                return
            }
            let mutation = Panform.InsertBakeryMutation(latitude: String(latitude),
                                                        longitude: String(longitude),
                                                        name: place.name,
                                                        placeId: place.placeID)
            apolloClient.apollo.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let idString = graphQLResult.data?.insert_bakeries_one?.id,
                       let bakeryID = UUID(uuidString: idString) {
                        continuation.resume(returning: bakeryID)
                    } else if let error = graphQLResult.errors?.first {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(throwing: NSError())
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func uploadImage(of bakeryPostDraft: BakeryPostDraft) async throws -> [URL] {
        return try await withCheckedThrowingContinuation { continuation in
            bakeryNetworkService.uploadImages(bakeryPostDraft) { urls in
                continuation.resume(returning: urls)
            }
        }
    }
}

// MARK: - Outputs
extension BakeryPostViewModel {
    var bakeryPostDraftViewModels: [BakeryPostDraftCellViewModel] {
        return bakeryPostDrafts.map {
            return BakeryPostDraftCellViewModel(postDraft: $0,
                                                bakeryStorageService: bakeryStorageService,
                                                onDelete: {[weak self] in
                self?.reloadDrafts()
            },
                                                didRequestToPost: { [weak self] postDraft in
                self?.postReviews(of: postDraft)
            })
        }
    }

    var bakeryPostCellViewModels: [BakeryPostCellViewModel] {
        return breads.map { bread in
            BakeryPostCellViewModel(bread: bread,
                                    reviews: breadReviews.filter { $0.breadID == bread.id },
                                    photos: breadPhotos.filter { $0.breadID == bread.id },
                                    didRequestToAddReview: { [weak self] bread in
                self?.addNewPost(for: bread)
            })
        }
    }
}

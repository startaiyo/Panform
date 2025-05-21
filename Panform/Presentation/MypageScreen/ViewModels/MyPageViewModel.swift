//
//  MyPageViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/27.
//

import SwiftUI

protocol MyPageViewModelProtocol: ObservableObject {

}

final class MyPageViewModel: MyPageViewModelProtocol {
    @Published var breads: [BreadModel] = []
    @Published var breadReviews: [BreadReviewModel] = []
    @Published var breadPhotos: [BreadPhotoModel] = []
    @Published var currentUser: UserModel?
    private let apolloClient: GraphQLClient
    private let authNetworkService: AuthNetworkServiceProtocol
    private let onLoggedOut: () -> Void

    init(apolloClient: GraphQLClient,
         authNetworkService: AuthNetworkServiceProtocol,
         onLoggedOut: @escaping () -> Void) {
        self.apolloClient = apolloClient
        self.authNetworkService = authNetworkService
        self.onLoggedOut = onLoggedOut
        updateCurrentUser()
        getPostDataOfUser()
    }
}

// MARK: - Private functions
private extension MyPageViewModel {
    func updateCurrentUser() {
        authNetworkService.getCurrentPanformUser { [weak self] currentUser in
            self?.currentUser = currentUser
        }
    }

    func getPostDataOfUser() {
        breads = []
        breadPhotos = []
        breadReviews = []
        authNetworkService.getCurrentPanformUser { [weak self] currentUser in
            guard let self,
                  let currentUserID = currentUser?.id.uuidString
            else {
                return
            }
            apolloClient.apollo.fetch(query: Panform.GetUserBreadReviewsQuery(userId: currentUserID),
                                      cachePolicy: .fetchIgnoringCacheCompletely) { result in
                guard let bakeries = try? result.get().data?.bakeries else {
                    return
                }
                bakeries.forEach { bakery in
                    bakery.breads.forEach { bread in
                        if let breadID = UUID(uuidString: bread.id),
                           let bakeryID = UUID(uuidString: bread.bakeryId) {
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
}

// MARK: - Inputs
extension MyPageViewModel {
    func reload() {
        updateCurrentUser()
        getPostDataOfUser()
    }

    func logout() {
        authNetworkService.logout()
        onLoggedOut()
    }
}

// MARK: - Outputs
extension MyPageViewModel {
    var bakeryPostCellViewModels: [BakeryPostCellViewModel] {
        return breads.map { bread in
            BakeryPostCellViewModel(bread: bread,
                                    reviews: breadReviews.filter { $0.breadID == bread.id },
                                    photos: breadPhotos.filter { $0.breadID == bread.id },
                                    didRequestToAddReview: nil)
        }
    }

    var editProfileViewModel: EditProfileViewModel {
        return .init(authNetworkService: authNetworkService,
                     apolloClient: apolloClient,
                     bakeryStorageService: BakeryStorageService(),
                     onDismiss: { [weak self] in
            self?.updateCurrentUser()
        },
                     onDeleteAccount: { [weak self] in
            self?.onLoggedOut()
        })
    }

    var currentPanformUser: UserModel? {
        return currentUser
    }
}

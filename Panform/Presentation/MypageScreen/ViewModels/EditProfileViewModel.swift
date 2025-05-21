//
//  EditProfileViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

protocol EditProfileViewModelProtocol: ObservableObject {
    
}

final class EditProfileViewModel: EditProfileViewModelProtocol {
    @Published var name = ""
    @Published var description = ""
    @Published var avatarURL = ""
    @Published var shouldShowLoading = false
    private let authNetworkService: AuthNetworkServiceProtocol
    private let bakeryStroageService: BakeryStorageServiceProtocol
    private let apolloClient: GraphQLClient
    let onDismiss: () -> Void
    let onDeleteAccount: () -> Void

    init(authNetworkService: AuthNetworkServiceProtocol,
         apolloClient: GraphQLClient,
         bakeryStorageService: BakeryStorageServiceProtocol,
         onDismiss: @escaping () -> Void,
         onDeleteAccount: @escaping () -> Void) {
        self.authNetworkService = authNetworkService
        self.apolloClient = apolloClient
        self.bakeryStroageService = bakeryStorageService
        self.onDismiss = onDismiss
        self.onDeleteAccount = onDeleteAccount
        authNetworkService.getCurrentPanformUser { [weak self] currentUserSettings in
            guard let currentUserSettings else { return }
            self?.name = currentUserSettings.name
            self?.description = currentUserSettings.description
            if let avatarURL = currentUserSettings.avatarURL?.absoluteString {
                self?.avatarURL = avatarURL
            }
        }
    }

    func updateUserProfile(onSuccess: @escaping () -> Void) {
        authNetworkService.getCurrentPanformUser { [weak self] currentPanformUser in
            guard let self,
                  let currentPanformUser
            else {
                return
            }
            authNetworkService.updateUserInfo(id: currentPanformUser.id.uuidString,
                                              name: name,
                                              description: description,
                                              avatarURL: avatarURL) { result in
                switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    func changeImage(imageData: Data) {
        authNetworkService.getCurrentPanformUser { [weak self] currentPanformUser in
            guard let self,
                  let currentPanformUser
            else {
                return
            }
            authNetworkService.uploadProfileImage(of: currentPanformUser.id,
                                                  imageData: imageData) { [weak self] url in
                self?.avatarURL = url.absoluteString
            }
        }
    }

    func deleteAccount() {
        shouldShowLoading = true
        guard let uid = authNetworkService.currentUser?.uid else { return }
        let mutation = Panform.DeleteUserMutation(uid: uid)
        apolloClient.apollo.perform(mutation: mutation) { [weak self] result in
            switch result {
                case .success:
                    self?.resetData()
                case .failure(let error):
                    print(error)
                    self?.shouldShowLoading = false
            }
        }
    }

    func resetData() {
        bakeryStroageService.resetData { [weak self] result in
            switch result {
                case .success:
                    self?.authNetworkService.deleteAccount { result in
                        switch result {
                            case .success:
                                self?.onDeleteAccount()
                            case .failure(let error):
                                print(error)
                        }
                        self?.shouldShowLoading = false
                    }
                case .failure(let error):
                    print(error)
                    self?.shouldShowLoading = false
            }
        }
    }
}

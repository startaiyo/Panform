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
    private let authNetworkService: AuthNetworkServiceProtocol
    let onDismiss: () -> Void

    init(authNetworkService: AuthNetworkServiceProtocol,
         onDismiss: @escaping () -> Void) {
        self.authNetworkService = authNetworkService
        self.onDismiss = onDismiss
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
}

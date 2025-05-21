//
//  SignUpViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

protocol SignUpViewModelProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    func signUp(onSuccess: @escaping () -> Void)
}

final class SignUpViewModel: SignUpViewModelProtocol {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var shouldShowLoading = false
    private let authNetworkService: AuthNetworkService

    init(authNetworkService: AuthNetworkService) {
        self.authNetworkService = authNetworkService
    }

    func signUp(onSuccess: @escaping () -> Void) {
        authNetworkService.signUp(email: email,
                                  password: password) { [weak self] result in
            switch result {
                case .success(let uid):
                    self?.createUserInfo(of: uid) {
                        onSuccess()
                    }
                case .failure(let error):
                    print(error)
                    self?.shouldShowLoading = false
            }
        }
    }
}

private extension SignUpViewModel {
    func createUserInfo(of uid: String,
                        onSuccess: @escaping () -> Void) {
        shouldShowLoading = true
        authNetworkService.createUserInfo(uid: uid,
                                          email: email,
                                          name: name) { [weak self] result in
            switch result {
                case .success:
                    onSuccess()
                case .failure(let error):
                    print(error)
            }
            self?.shouldShowLoading = false
        }
    }
}

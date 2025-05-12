//
//  LoginViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

protocol LoginViewModelProtocol: ObservableObject {
    var email: String { get set }
    var password: String { get set }
    var signUpViewModel: SignUpViewModel { get }
    func login()
}

final class LoginViewModel: LoginViewModelProtocol {
    @Published var email = ""
    @Published var password = ""
    private let authNetworkService: AuthNetworkService
    private let onLoginSuccess: () -> Void

    init(authNetworkService: AuthNetworkService,
         onLoginSuccess: @escaping () -> Void) {
        self.authNetworkService = authNetworkService
        self.onLoginSuccess = onLoginSuccess
    }

    func login() {
        authNetworkService.login(email: email,
                                 password: password) { [weak self] result in
            switch result {
                case .success:
                    self?.onLoginSuccess()
                case .failure(let error):
                    print(error)
            }
        }
    }
}

// MARK: - Outputs
extension LoginViewModel {
    var signUpViewModel: SignUpViewModel {
        return .init(authNetworkService: authNetworkService)
    }
}

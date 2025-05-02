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
    func login()
}

final class LoginViewModel: LoginViewModelProtocol {
    @Published var email = ""
    @Published var password = ""
    private let onLoginSuccess: () -> Void

    init(onLoginSuccess: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
    }

    func login() {
        onLoginSuccess()
    }
}

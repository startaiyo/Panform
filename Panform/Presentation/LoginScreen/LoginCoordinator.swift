//
//  LoginCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/30.
//

import SwiftUI

final class LoginCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let tabsCoordinator: TabsCoordinator
    private let authNetworkService = AuthNetworkService.shared

    init(navigationController: UINavigationController,
         tabsCoordinator: TabsCoordinator) {
        self.navigationController = navigationController
        self.tabsCoordinator = tabsCoordinator
    }

    func start() {
        showLoginScreen()
    }
}

// MARK: Private functions
private extension LoginCoordinator {
    func showLoginScreen() {
        let viewModel = LoginViewModel(authNetworkService: authNetworkService,
                                       onLoginSuccess: { [weak self] in
            self?.showTabsScreen()
        })
        let viewController = UIHostingController(rootView: LoginView(viewModel: viewModel))
        navigationController.setViewControllers([viewController],
                                                animated: false)
    }

    func showTabsScreen() {
        tabsCoordinator.start()
    }
}

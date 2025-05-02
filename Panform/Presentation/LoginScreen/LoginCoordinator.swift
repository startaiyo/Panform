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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabsCoordinator = TabsCoordinator(navigationController: navigationController)
    }

    func start() {
        showLoginScreen()
    }
}

// MARK: Private functions
private extension LoginCoordinator {
    func showLoginScreen() {
        let viewModel = LoginViewModel(onLoginSuccess: { [weak self] in
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

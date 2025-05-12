//
//  AppCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/30.
//

import UIKit

final class AppCoordinator: Coordinator {
    private let window: UIWindow?
    private let rootViewController: UINavigationController
    private let loginCoordinator: LoginCoordinator
    private let tabsCoordinator: TabsCoordinator
    private let authNetworkService: AuthNetworkServiceProtocol = AuthNetworkService.shared

    init(window: UIWindow?) {
        self.window = window
        self.rootViewController = UINavigationController()
        self.tabsCoordinator = TabsCoordinator(navigationController: rootViewController)
        self.loginCoordinator = LoginCoordinator(navigationController: rootViewController,
                                                 tabsCoordinator: tabsCoordinator)
        tabsCoordinator.delegate = self
    }

    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        if authNetworkService.currentUser == nil {
            loginCoordinator.start()
        } else {
            tabsCoordinator.start()
        }
    }
}

// MARK: - Private functions
private extension AppCoordinator {
    func resetToRootScreen() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        rootViewController.popToRootViewController(animated: false)
        loginCoordinator.start()
    }
}

extension AppCoordinator: TabsCoordinatorDelegate {
    func didLoggedOut() {
        resetToRootScreen()
    }
}

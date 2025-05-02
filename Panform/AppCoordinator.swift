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

    init(window: UIWindow?) {
        self.window = window
        self.rootViewController = UINavigationController()
        self.loginCoordinator = LoginCoordinator(navigationController: rootViewController)
    }

    func start() {
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        loginCoordinator.start()
    }
}

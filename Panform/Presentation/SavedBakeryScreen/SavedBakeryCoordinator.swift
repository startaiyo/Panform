//
//  SavedBakeryCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

final class SavedBakeryCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let bakeryID: BakeryID
    private let bakeryStorageService = BakeryStorageService()
    private let graphQLClient = GraphQLClient.shared

    init(navigationController: UINavigationController,
         bakeryID: BakeryID) {
        self.navigationController = navigationController
        self.bakeryID = bakeryID
    }

    func start() {
        showSavedBakeryScreen(of: bakeryID)
    }
}

// MARK: - Private functions
private extension SavedBakeryCoordinator {
    func showSavedBakeryScreen(of bakeryID: BakeryID) {
        let viewModel = SavedBakeryViewModel(bakeryID: bakeryID,
                                             apolloClient: graphQLClient,
                                             bakeryStorageService: bakeryStorageService)
        let viewController = UIHostingController(rootView: SavedBakeryView(viewModel: viewModel)
        )
        navigationController.pushViewController(viewController,
                                                animated: true)
    }
}

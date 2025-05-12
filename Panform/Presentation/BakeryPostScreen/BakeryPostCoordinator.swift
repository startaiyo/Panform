//
//  BakeryPostCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftUI

final class BakeryPostCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let bakeryID: BakeryID
    private let authNetworkService = AuthNetworkService.shared
    private let bakeryStorageService = BakeryStorageService()
    private let bakeryNetworkService = BakeryNetworkService()
    private let graphQLClient = GraphQLClient.shared

    init(navigationController: UINavigationController,
         bakeryID: BakeryID) {
        self.navigationController = navigationController
        self.bakeryID = bakeryID
    }

    func start() {
        showBakeryPostScreen(of: bakeryID)
    }
}

// MARK: - Private functions
private extension BakeryPostCoordinator {
    func showBakeryPostScreen(of bakeryID: BakeryID) {
        let viewModel = BakeryPostViewModel(bakeryID: bakeryID,
                                            apolloClient: graphQLClient,
                                            authNetworkService: authNetworkService,
                                            bakeryStorageService: bakeryStorageService,
                                            bakeryNetworkService: bakeryNetworkService)
        let viewController = UIHostingController(rootView:
            BakeryPostView(viewModel: viewModel)
        )
        navigationController.pushViewController(viewController,
                                                animated: true)
    }
}

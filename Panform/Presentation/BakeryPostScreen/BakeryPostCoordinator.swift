//
//  BakeryPostCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftUI

final class BakeryPostCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let bakery: BakeryModel?
    private let place: Place
    private let authNetworkService = AuthNetworkService.shared
    private let bakeryStorageService = BakeryStorageService()
    private let bakeryNetworkService = BakeryNetworkService()
    private let graphQLClient = GraphQLClient.shared

    init(bakery: BakeryModel?,
         place: Place,
         navigationController: UINavigationController) {
        self.bakery = bakery
        self.place = place
        self.navigationController = navigationController
    }

    func start() {
        showBakeryPostScreen()
    }
}

// MARK: - Private functions
private extension BakeryPostCoordinator {
    func showBakeryPostScreen() {
        let viewModel = BakeryPostViewModel(apolloClient: graphQLClient,
                                            bakery: bakery,
                                            place: place,
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

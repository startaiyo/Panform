//
//  BakeryDetailCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

final class BakeryDetailCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let graphQLClient = GraphQLClient.shared
    private let authNetworkService = AuthNetworkService.shared
    private let bakeryStorageService = BakeryStorageService()
    private let place: Place
    private let bakery: BakeryModel?

    init(navigationController: UINavigationController,
         place: Place,
         bakery: BakeryModel?) {
        self.navigationController = navigationController
        self.place = place
        self.bakery = bakery
    }

    func start() {
        showBakeryDetailScreen(place,
                               with: bakery)
    }
}

// MARK: Private functions
private extension BakeryDetailCoordinator {
    func showBakeryDetailScreen(_ place: Place,
                                with bakery: BakeryModel?) {
        let viewModel = BakeryDetailViewModel(bakery: bakery,
                                              place: place,
                                              apolloClient: graphQLClient,
                                              authNetworkService: authNetworkService,
                                              bakeryStorageService: bakeryStorageService,
                                              didRequestToShowBakeryPost: { [weak self] in
            self?.showBakeryPostScreen()
        })
        let viewController = UIHostingController(rootView: BakeryDetailView(viewModel: viewModel))
        navigationController.pushViewController(viewController,
                                                animated: true)
    }

    func showBakeryPostScreen() {
        let bakeryPostCoordinator = BakeryPostCoordinator(bakery: bakery,
                                                          place: place,
                                                          navigationController:navigationController)
        bakeryPostCoordinator.start()
    }
}

//
//  TabsCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

protocol TabsCoordinatorDelegate: AnyObject {
    func didLoggedOut()
}

final class TabsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var bakeryDetailCoordinator: BakeryDetailCoordinator?
    private var savedBakeryCoordinator: SavedBakeryCoordinator?
    private let graphQLClient = GraphQLClient.shared
    private let authNetworkService = AuthNetworkService.shared
    weak var delegate: TabsCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabsScreen()
    }
}

// MARK: Private functions
private extension TabsCoordinator {
    func showTabsScreen() {
        let searchViewModel = SearchViewModel(apolloClient: graphQLClient,
                                              didRequestToShowBakeryDetail: { [weak self] bakery in
            self?.didRequestToShowBakeryDetail(bakery)
        })
        let savedViewModel = SavedViewModel(apolloClient: GraphQLClient.shared,
                                            bakeryStorageService: BakeryStorageService(),
                                            didRequestToSavedBakeryScreen: { [weak self] bakeryID in
            self?.didRequestToShowSavedBakeryScreen(bakeryID)
        })
        let myPageViewModel = MyPageViewModel(apolloClient: graphQLClient,
                                              authNetworkService: authNetworkService,
                                              onLoggedOut: { [weak self] in
            self?.delegate?.didLoggedOut()
        })
        let tabsViewModel = TabsViewModel(searchViewModel: searchViewModel,
                                          savedViewModel: savedViewModel,
                                          myPageViewModel: myPageViewModel)
        let viewController = UIHostingController(rootView: TabsView(viewModel: tabsViewModel))
        navigationController.pushViewController(viewController,
                                                animated: false)
    }

    func didRequestToShowBakeryDetail(_ bakery: BakeryModel) {
        let bakeryDetailCoordinator = BakeryDetailCoordinator(navigationController: navigationController,
                                                              bakery: bakery)
        self.bakeryDetailCoordinator = bakeryDetailCoordinator
        bakeryDetailCoordinator.start()
    }

    func didRequestToShowSavedBakeryScreen(_ bakeryID: BakeryID) {
        let savedBakeryCoordinator = SavedBakeryCoordinator(navigationController: navigationController,
                                                             bakeryID: bakeryID)
        self.savedBakeryCoordinator = savedBakeryCoordinator
        savedBakeryCoordinator.start()
    }
}

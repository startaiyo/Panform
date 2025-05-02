//
//  TabsCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

final class TabsCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private var bakeryDetailCoordinator: BakeryDetailCoordinator?

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
        let searchViewModel = SearchViewModel(didRequestToShowBakeryDetail: { [weak self] in
            self?.didRequestToShowBakeryDetail(.stub())
        })
        let savedViewModel = SavedViewModel(bakeries: [.stub(), .stub()],
                                            breads: [.stub(), .stub()],
                                            breadReviews: [.stub()],
                                            breadPhotos: [.stub()])
        let tabsViewModel = TabsViewModel(searchViewModel: searchViewModel,
                                          savedViewModel: savedViewModel)
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
}

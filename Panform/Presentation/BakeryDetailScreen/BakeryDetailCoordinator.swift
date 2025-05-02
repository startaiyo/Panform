//
//  BakeryDetailCoordinator.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

final class BakeryDetailCoordinator: Coordinator {
    private let navigationController: UINavigationController
    private let bakery: BakeryModel

    init(navigationController: UINavigationController,
         bakery: BakeryModel) {
        self.navigationController = navigationController
        self.bakery = bakery
    }

    func start() {
        showBakeryDetailScreen(with: bakery)
    }
}

// MARK: Private functions
private extension BakeryDetailCoordinator {
    func showBakeryDetailScreen(with bakery: BakeryModel) {
        let viewModel = BakeryDetailViewModel(bakery: bakery,
                                              breads: [BreadModel.stub(), BreadModel.stub()],
                                              breadReviews: [BreadReviewModel.stub(), BreadReviewModel.stub()],
                                              breadPhotos: [BreadPhotoModel.stub(), BreadPhotoModel.stub()],
                                              didRequestToShowBakeryPost: { [weak self] in
            self?.showBakeryPostScreen(of: bakery.id)
        })
        let viewController = UIHostingController(rootView: BakeryDetailView(viewModel: viewModel))
        navigationController.pushViewController(viewController,
                                                animated: true)
    }

    func showBakeryPostScreen(of bakeryID: BakeryID) {
        let bakeryPostCoordinator = BakeryPostCoordinator(navigationController: navigationController,
                                                          bakeryID: bakeryID)
        bakeryPostCoordinator.start()
    }
}

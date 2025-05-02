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
        let viewModel = BakeryPostViewModel(breads: [BreadModel.stub()],
                                            breadReviews: [BreadReviewModel.stub()],
                                            breadPhotos: [BreadPhotoModel.stub()],
                                            bakeryID: bakeryID)
        let viewController = UIHostingController(rootView:
            BakeryPostView(viewModel: viewModel)
        )
        navigationController.pushViewController(viewController,
                                                animated: true)
    }
}

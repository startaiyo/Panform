//
//  SearchViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol SearchViewModelProtocol: ObservableObject {
    func showDetail()
}

final class SearchViewModel: SearchViewModelProtocol {
    let didRequestToShowBakeryDetail: () -> Void

    init(didRequestToShowBakeryDetail: @escaping () -> Void) {
        self.didRequestToShowBakeryDetail = didRequestToShowBakeryDetail
    }

    func showDetail() {
        didRequestToShowBakeryDetail()
    }
}

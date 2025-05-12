//
//  SearchViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol SearchViewModelProtocol: ObservableObject {
    func showDetail(of bakery: BakeryModel)
}

final class SearchViewModel: SearchViewModelProtocol {
    let didRequestToShowBakeryDetail: (BakeryModel) -> Void
    let apolloClient: GraphQLClient
    @Published var bakeries: [BakeryModel] = []

    init(apolloClient: GraphQLClient,
         didRequestToShowBakeryDetail: @escaping (BakeryModel) -> Void) {
        self.apolloClient = apolloClient
        self.didRequestToShowBakeryDetail = didRequestToShowBakeryDetail
        getBakeriesInfo()
    }

    

    func showDetail(of bakery: BakeryModel) {
        didRequestToShowBakeryDetail(bakery)
    }
}

// MARK: - Private functions
private extension SearchViewModel {
    func getBakeriesInfo() {
        bakeries = []
        apolloClient.apollo.fetch(query: Panform.GetBakeriesInfoQuery()) { result in
            let data = try? result.get().data?.bakeries
            data?.forEach {
                guard let id = UUID(uuidString: $0.id),
                      let openAt = TimeOnly(hour: $0.openAt, minute: 0),
                      let closeAt = TimeOnly(hour: $0.closeAt, minute: 0),
                      let latitude = Double($0.latitude),
                      let longitude = Double($0.longitude) else {
                    return
                }
                self.bakeries.append(BakeryModel(id: id,
                                                 name: $0.name,
                                                 memo: "",
                                                 openAt: openAt,
                                                 closeAt: closeAt,
                                                 openingDays: $0.openingDays.compactMap { day in
                        .init(rawValue: day)
                },
                                                 location: .init(latitude: latitude,
                                                                 longitude: longitude)))
            }
        }
    }
}

// MARK: - Inputs
extension SearchViewModel {
    func reload() {
        getBakeriesInfo()
    }
}

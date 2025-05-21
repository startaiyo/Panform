//
//  SearchViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol SearchViewModelProtocol: ObservableObject {
    func showDetail(of place: Place, andBakery bakery: BakeryModel?)
}

final class SearchViewModel: SearchViewModelProtocol {
    let didRequestToShowBakeryDetail: (Place, BakeryModel?) -> Void
    let apolloClient: GraphQLClient
    @Published var bakeries: [BakeryModel] = []

    init(apolloClient: GraphQLClient,
         didRequestToShowBakeryDetail: @escaping (Place, BakeryModel?) -> Void) {
        self.apolloClient = apolloClient
        self.didRequestToShowBakeryDetail = didRequestToShowBakeryDetail
        getBakeriesInfo()
    }

    func showDetail(of place: Place, andBakery bakery: BakeryModel?) {
        didRequestToShowBakeryDetail(place, bakery)
    }
}

// MARK: - Private functions
private extension SearchViewModel {
    func getBakeriesInfo() {
        bakeries = []
        apolloClient.apollo.fetch(query: Panform.GetBakeriesInfoQuery(),
                                  cachePolicy: .fetchIgnoringCacheCompletely) { result in
            let data = try? result.get().data?.bakeries
            data?.forEach {
                guard let id = UUID(uuidString: $0.id),
                      let latitude = Double($0.latitude),
                      let longitude = Double($0.longitude) else {
                    return
                }
                self.bakeries.append(BakeryModel(id: id,
                                                 name: $0.name,
                                                 openAt: $0.openAt == nil ? nil : .init(hour: $0.openAt!,
                                                                                        minute: 0),
                                                 closeAt: $0.closeAt == nil ? nil : .init(hour: $0.closeAt!,
                                                                                          minute: 0),
                                                 openingDays: $0.openingDays?.compactMap { day in
                        .init(rawValue: day)
                } ?? [],
                                                 location: .init(latitude: latitude,
                                                                 longitude: longitude),
                                                 placeID: $0.placeId))
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

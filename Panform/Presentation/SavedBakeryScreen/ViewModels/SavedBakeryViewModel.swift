//
//  SavedBakeryViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftData
import SwiftUI

protocol SavedBakeryViewModelProtocol: ObservableObject {

}

final class SavedBakeryViewModel: SavedBakeryViewModelProtocol {
    @Published var title: String?
    @Published var breads: [BreadModel] = []
    @Published var savedBreads: [SavedBread] = []
    private let bakeryID: BakeryID
    private let apolloClient: GraphQLClient
    private let bakeryStorageService: BakeryStorageServiceProtocol

    init(bakeryID: BakeryID,
         apolloClient: GraphQLClient,
         bakeryStorageService: BakeryStorageServiceProtocol) {
        self.bakeryID = bakeryID
        self.apolloClient = apolloClient
        self.bakeryStorageService = bakeryStorageService
        getBakeryData()
    }
}

// MARK: - Private functions
private extension SavedBakeryViewModel {
    func getBakeryData() {
        breads = []
        savedBreads = bakeryStorageService.getSavedBreads()
        apolloClient.apollo.fetch(query: Panform.GetBakeryDataQuery(bakeryID: bakeryID.uuidString)) { [weak self] result in
            guard let self,
                  let bakery = try? result.get().data?.bakeries.first
            else {
                return
            }
            title = bakery.name
            bakery.breads.forEach { bread in
                if let breadID = UUID(uuidString: bread.id) {
                    self.breads.append(.init(id: breadID,
                                             name: bread.name,
                                             price: bread.price,
                                             bakeryID: self.bakeryID))
                }
            }
        }
    }
}

// MARK: - Outputs
extension SavedBakeryViewModel {
    var savedBakeryBreadCellViewModels: [SavedBakeryBreadCellViewModel] {
        return savedBreads.map { savedBread in
                .init(bread: breads.first(where: { savedBread.breadID == $0.id }),
                      savedBread: savedBread)
        }
    }
}

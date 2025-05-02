//
//  BakeryPostViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftData
import SwiftUI

protocol BakeryPostViewModelProtocol: ObservableObject {

}

final class BakeryPostViewModel: BakeryPostViewModelProtocol {
    @Published var breads: [BreadModel]
    @Published var breadReviews: [BreadReviewModel]
    @Published var breadPhotos: [BreadPhotoModel]
    @Published var bakeryPostDrafts: [BakeryPostDraftModel] = []

    private let bakeryID: BakeryID

    init(breads: [BreadModel],
         breadReviews: [BreadReviewModel],
         breadPhotos: [BreadPhotoModel],
         bakeryID: BakeryID) {
        self.breads = breads
        self.breadReviews = breadReviews
        self.breadPhotos = breadPhotos
        self.bakeryID = bakeryID
    }

    func addNewPost() {
        let newDraft = BakeryPostDraftModel(id: UUID(),
                                            bakeryID: bakeryID,
                                            breadName: "",
                                            score: 0,
                                            comment: "",
                                            selectedPhotos: [])
    }
}

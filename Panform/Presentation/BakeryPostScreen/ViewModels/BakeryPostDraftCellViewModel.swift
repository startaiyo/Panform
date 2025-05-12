//
//  BakeryPostDraftCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/27.
//

import SwiftUI

protocol BakeryPostDraftCellViewModelProtocol: ObservableObject {
    
}

final class BakeryPostDraftCellViewModel: BakeryPostCellViewModelProtocol, Identifiable {
    var postDraft: BakeryPostDraft
    private let bakeryStorageService: BakeryStorageServiceProtocol
    private let onDelete: () -> Void
    private let didRequestToPost: (BakeryPostDraft) -> Void

    init(postDraft: BakeryPostDraft,
         bakeryStorageService: BakeryStorageServiceProtocol,
         onDelete: @escaping () -> Void,
         didRequestToPost: @escaping (BakeryPostDraft) -> Void) {
        self.postDraft = postDraft
        self.bakeryStorageService = bakeryStorageService
        self.onDelete = onDelete
        self.didRequestToPost = didRequestToPost
    }
}

// MARK: - Inputs
extension BakeryPostDraftCellViewModel {
    func saveDraft() {
        bakeryStorageService.updateBakeryPostDraft()
    }

    func deleteDraft() {
        bakeryStorageService.deleteBakeryPostDraft(postDraft)
        onDelete()
    }

    func postReviews() {
        didRequestToPost(postDraft)
    }
}

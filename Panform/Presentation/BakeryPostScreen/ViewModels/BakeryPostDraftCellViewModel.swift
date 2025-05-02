//
//  BakeryPostDraftCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/27.
//

import SwiftUI

protocol BakeryPostDraftCellViewModelProtocol: ObservableObject {
    
}

final class BakeryPostDraftCellViewModel: BakeryPostCellViewModelProtocol {
    var postDraft: BakeryPostDraftModel

    init(postDraft: BakeryPostDraftModel) {
        self.postDraft = postDraft
    }
}

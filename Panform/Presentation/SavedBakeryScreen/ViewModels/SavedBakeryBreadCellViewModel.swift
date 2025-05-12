//
//  SavedBakeryBreadCellViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

protocol SavedBakeryBreadCellViewModelProtocol: ObservableObject {
    
}

final class SavedBakeryBreadCellViewModel: SavedBakeryBreadCellViewModelProtocol, Identifiable  {
    let bread: BreadModel?
    let savedBread: SavedBread

    init(bread: BreadModel?,
         savedBread: SavedBread) {
        self.bread = bread
        self.savedBread = savedBread
    }
}

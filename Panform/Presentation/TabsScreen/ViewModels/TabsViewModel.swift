//
//  TabsViewModel.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

protocol TabsViewModelProtocol: ObservableObject {
    
}

final class TabsViewModel: TabsViewModelProtocol {
    @Published var searchViewModel: SearchViewModel
    @Published var savedViewModel: SavedViewModel

    init(searchViewModel: SearchViewModel,
         savedViewModel: SavedViewModel) {
        self.searchViewModel = searchViewModel
        self.savedViewModel = savedViewModel
    }
}

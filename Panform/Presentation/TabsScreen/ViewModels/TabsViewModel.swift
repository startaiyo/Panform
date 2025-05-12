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
    @Published var myPageViewModel: MyPageViewModel

    init(searchViewModel: SearchViewModel,
         savedViewModel: SavedViewModel,
         myPageViewModel: MyPageViewModel) {
        self.searchViewModel = searchViewModel
        self.savedViewModel = savedViewModel
        self.myPageViewModel = myPageViewModel
    }
}

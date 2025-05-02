//
//  SearchView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

struct SearchView: View {
    @State private var searchQuery = ""
    @ObservedObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(text: $searchQuery)
            Button {
                viewModel.showDetail()
            } label: {
                Text("Go to detail")
            }
//            MapView(searchQuery: $searchQuery)
//                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(didRequestToShowBakeryDetail: { }))
}

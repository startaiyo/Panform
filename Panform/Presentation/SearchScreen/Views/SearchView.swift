//
//  SearchView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @State private var searchQuery = ""
    @ObservedObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchBar(onSearchButtonClicked: { searchText in
                searchQuery = searchText
            })
            MapView(searchQuery: $searchQuery,
                    bakeries: $viewModel.bakeries,
                    onTap: { bakery in
                viewModel.showDetail(of: bakery)
            })
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(apolloClient: GraphQLClient.shared, didRequestToShowBakeryDetail: { _ in }))
}

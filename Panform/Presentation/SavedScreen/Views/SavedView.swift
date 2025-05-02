//
//  SavedView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI
import GoogleMaps

struct SavedView: View {
    @StateObject var viewModel: SavedViewModel
    @State private var searchQuery: String = ""

    var body: some View {
        VStack(spacing: 0) {
            // MapView with binding searchQuery
//            MapView(searchQuery: $searchQuery)
//                .frame(height: 250)

            // Scrollable list of bakeries
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.bakeries, id: \.id) { bakery in
                        SavedBakeryCell(
                            viewModel: SavedBakeryCellViewModel(
                                bakery: bakery,
                                breads: viewModel.breads,
                                breadReviews: viewModel.breadReviews,
                                breadPhotos: viewModel.breadPhotos
                            )
                        )
                    }
                }
                .padding(.top)
            }
        }
        .background(Color.creme.ignoresSafeArea())
    }
}


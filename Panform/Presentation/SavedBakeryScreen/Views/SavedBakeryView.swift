//
//  SavedBakeryView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

struct SavedBakeryView: View {
    @ObservedObject private var viewModel: SavedBakeryViewModel

    init(viewModel: SavedBakeryViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.savedBakeryBreadCellViewModels) { cellViewModel in
                    SavedBakeryBreadCell(viewModel: cellViewModel)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .background(Color.creme.ignoresSafeArea())
        .navigationTitle(viewModel.title ?? "")
    }
}


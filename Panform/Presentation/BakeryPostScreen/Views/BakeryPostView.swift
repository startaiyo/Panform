//
//  BakeryPostView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftUI

struct BakeryPostView: View {
    @ObservedObject private var viewModel: BakeryPostViewModel

    init(viewModel: BakeryPostViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.breads) { bread in
                    BakeryPostCell(viewModel: BakeryPostCellViewModel(bread: bread, reviews: viewModel.breadReviews, photos: viewModel.breadPhotos))
                        .listRowBackground(Color.clear)
                }

                ForEach(viewModel.bakeryPostDrafts) { bakeryPostDraft in
                    BakeryPostDraftCell(viewModel: .init(postDraft: bakeryPostDraft))
                        .listRowBackground(Color.clear)
                }

                Button(action: {
                    viewModel.addNewPost()
                }) {
                    Text("＋")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        
                }
                .buttonStyle(PlainButtonStyle())
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .background(Color.clear)
        }
        .background(Color.creme.ignoresSafeArea())
    }
}

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
        ZStack {
            VStack {
                List {
                    ForEach(viewModel.bakeryPostCellViewModels) { cellViewModel in
                        BakeryPostCell(viewModel: cellViewModel)
                            .listRowBackground(Color.clear)
                    }

                    ForEach(viewModel.bakeryPostDraftViewModels) { cellViewModel in
                        BakeryPostDraftCell(viewModel: cellViewModel)
                            .listRowBackground(Color.clear)
                    }

                    Button(action: {
                        viewModel.addNewPost(for: nil)
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

            if viewModel.shouldShowLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
}

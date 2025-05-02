//
//  BakeryPostDraftCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/05.
//

import SwiftUI

struct BakeryPostDraftCell: View {
    @ObservedObject var viewModel: BakeryPostDraftCellViewModel

    private let scores = stride(from: 1.0, through: 5.0, by: 0.1).map { Double(round($0 * 10) / 10) }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title Bar
            HStack {
                TextField("Bread name", text: $viewModel.postDraft.breadName)
                    .font(.headline)
                    .foregroundColor(.white)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)

                Spacer()

                Button(action: {
                    // Handle save action
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.darkBlue)

            // Main Content
            VStack(alignment: .leading, spacing: 12) {
                // Score Picker
                HStack {
                    Text("Score")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    Picker(selection: $viewModel.postDraft.score, label: Text("")) {
                        ForEach(scores, id: \.self) { value in
                            Text(String(format: "%.1f", value))
                                .tag(value)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(width: 80)
                }

                // Comment Input
                TextEditor(text: $viewModel.postDraft.comment)
                    .frame(minHeight: 80)
                    .padding(6)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if viewModel.postDraft.breadName.isEmpty {
                                Text("please input the comment")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .allowsHitTesting(false)
                            }
                        },
                        alignment: .topLeading
                    )

                // Photo Add Button
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        Button(action: {
                            // Handle photo add
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                                    .font(.title)
                            }
                        }

                        // Optionally show selected photos
                        ForEach($viewModel.postDraft.selectedPhotos.indices, id: \.self) { index in
                            Image(uiImage: viewModel.postDraft.selectedImages[index])
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipped()
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
            .background(Color.skyBlue)
        }
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 2)
        .padding()
    }
}

//
//  BakeryPostDraftCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/05.
//

import PhotosUI
import SwiftUI

struct BakeryPostDraftCell: View {
    @ObservedObject var viewModel: BakeryPostDraftCellViewModel
    @State private var isPhotoPickerPresented = false
    @State private var selectedItems: [PhotosPickerItem] = []

    private let scores = stride(from: 1.0, through: 5.0, by: 0.1).map { Float(round($0 * 10) / 10) }

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
                    viewModel.postReviews()
                }) {
                    Text("Post")
                        .foregroundColor(.white)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    viewModel.saveDraft()
                }) {
                    Text("Save the draft")
                        .foregroundColor(.white)
                        .bold()
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    viewModel.deleteDraft()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.darkBlue)

            // Main Content
            VStack(alignment: .leading, spacing: 12) {
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

                HStack {
                    Text("Price")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    TextField("price", text: Binding(
                        get: { viewModel.postDraft.price == 0 ? "" : String(viewModel.postDraft.price) },
                        set: { viewModel.postDraft.price = Int($0) ?? 0 }
                    ))
                        .keyboardType(.decimalPad)
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(PlainTextFieldStyle())
                        .frame(width: 80)
                    Text("Yen")
                }

                // Comment Input
                TextEditor(text: $viewModel.postDraft.comment)
                    .frame(minHeight: 80)
                    .padding(6)
                    .background(Color.white)
                    .cornerRadius(8)
                    .overlay(
                        Group {
                            if viewModel.postDraft.comment.isEmpty {
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
                            isPhotoPickerPresented = true
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

                        ForEach(viewModel.postDraft.draftImages, id: \.self) { image in
                            if let uiImage = UIImage(data: image.imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .photosPicker(isPresented: $isPhotoPickerPresented,
                              selection: $selectedItems,
                              maxSelectionCount: 5,
                              matching: .images)
                .onChange(of: selectedItems) { newItems in
                    Task {
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self),
                               let image = UIImage(data: data),
                               let jpegData = image.jpegData(compressionQuality: 0.8) {
                                let imageData = BakeryPostDraftImage(id: UUID(),
                                                                     imageData: jpegData)
                                viewModel.postDraft.draftImages.append(imageData)
                            }
                        }
                    }
                }
                .onAppear {
                    
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

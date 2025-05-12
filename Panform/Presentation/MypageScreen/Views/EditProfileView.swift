//
//  EditProfileView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @ObservedObject private var viewModel: EditProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @Environment(\.dismiss) var dismiss

    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Avatar")) {
                    VStack {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            AsyncImage(url: URL(string: viewModel.avatarURL)) { phase in
                                switch phase {
                                case .success(let image):
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                default:
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                            }
                        }
                        
                        PhotosPicker("Change Avatar", selection: $selectedItem, matching: .images)
                            .onChange(of: selectedItem) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        viewModel.changeImage(imageData: data)
                                    }
                                }
                            }
                    }
                }
                
                Section(header: Text("Info")) {
                    TextField("Name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section {
                    Button("Save") {
                        viewModel.updateUserProfile {
                            viewModel.onDismiss()
                            dismiss()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Edit Profile")
        }
    }
}

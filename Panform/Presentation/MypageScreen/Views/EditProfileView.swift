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
    @State private var showDeleteAccountAlert = false
    @Environment(\.dismiss) var dismiss

    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            ZStack {
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
                                if let avatarURL = URL(string: viewModel.avatarURL) {
                                    AsyncImage(url: avatarURL) { phase in
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
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 100)
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
                        HStack {
                            Text("Name")
                            TextField("Name", text: $viewModel.name)
                        }
                        HStack {
                            Text("Description")
                            TextField("Description", text: $viewModel.description)
                        }
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
                    
                    Section {
                        Button("Delete Account", role: .destructive) {
                            showDeleteAccountAlert = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .alert(isPresented: $showDeleteAccountAlert) {
                            Alert(
                                title: Text("Are you sure deleting account?"),
                                message: Text("You will lose all data of this app."),
                                primaryButton: .default(
                                    Text("Cancel"),
                                    action: {
                                        showDeleteAccountAlert = false
                                    }
                                ),
                                secondaryButton: .destructive(
                                    Text("Delete"),
                                    action: {
                                        viewModel.deleteAccount()
                                    }
                                )
                            )
                        }
                    }
                }

                if viewModel.shouldShowLoading {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            .navigationTitle("Edit Profile")
        }
    }
}

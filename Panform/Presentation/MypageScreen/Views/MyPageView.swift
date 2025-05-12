//
//  MyPageView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

enum MyPageSegment: String, CaseIterable {
    case posts = "Posts"
    case favorites = "Favorites"
    case places = "Places"
}

struct MyPageView: View {
    @ObservedObject private var viewModel: MyPageViewModel
    @State private var selectedSegment: MyPageSegment = .posts
    @State private var isShowEditProfile = false

    init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let currentPanformUser = viewModel.currentPanformUser {
                HStack(alignment: .center, spacing: 16) {
                    AsyncImage(url: currentPanformUser.avatarURL) { phase in
                        switch phase {
                            case .empty:
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 80, height: 80)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            case .failure:
                                Circle()
                                    .fill(Color.red.opacity(0.3))
                                    .overlay(
                                        Image(systemName: "exclamationmark.triangle")
                                            .foregroundColor(.white)
                                    )
                                    .frame(width: 80, height: 80)
                            @unknown default:
                                EmptyView()
                        }
                    }
                    VStack(alignment: .leading) {
                        Text(currentPanformUser.name)
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.top)

                Text(currentPanformUser.description)
                    .font(.body)
                    .padding(.horizontal)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    isShowEditProfile.toggle()
                }) {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .underline()
                }
                Spacer()
                    .frame(width: 20)
                Button(action: {
                    viewModel.logout()
                }) {
                    Text("Logout")
                        .font(.subheadline)
                        .underline()
                }
                Spacer()
            }
            
//                Picker("", selection: $selectedSegment) {
//                    ForEach([MyPageSegment.posts], id: \.self) { segment in
//                        Text(segment.rawValue)
//                            .tag(segment)
//                    }
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .padding()
            Text("Posts")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.darkBlue)

            ScrollView {
                Group {
                    switch selectedSegment {
                    case .posts:
                        VStack(spacing: 8) {
                            ForEach(viewModel.bakeryPostCellViewModels) { cellViewModel in
                                BakeryPostCell(viewModel: cellViewModel)
                                    .listRowBackground(Color.clear)
                            }
                        }
                    case .favorites:
                        VStack {
                            Text("Favorites")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    case .places:
                        VStack {
                            Text("Places")
                                .font(.title3)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                .animation(.easeInOut, value: selectedSegment)
            }
        }
        .sheet(isPresented: $isShowEditProfile) {
            EditProfileView(viewModel: viewModel.editProfileViewModel)
        }
        .padding(.horizontal)
        .background(Color.creme.ignoresSafeArea())
        .navigationTitle("My Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}

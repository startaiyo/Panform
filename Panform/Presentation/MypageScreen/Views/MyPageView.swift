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
    @State private var selectedSegment: MyPageSegment = .posts

    private let user = UserModel(
        id: UUID(),
        name: "John Doe",
        email: "john@example.com",
        description: "Passionate about baking breads!",
        avatarURL: URL(string: "https://example.com/avatar.png")!
    )

    private let breadPosts: [BakeryRankingCellViewModel] = [.init(bread: .stub(),
                                                                  reviews: [.stub(), .stub()])]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 16) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 80)
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .background(Color.white)
                            .clipShape(Circle())
                            .offset(x: 8, y: 8)
                    }
                    VStack(alignment: .leading) {
                        Text(user.name)
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.top)

                Text(user.description)
                    .font(.body)
                    .padding(.horizontal)

                HStack {
                    Spacer()
                    Button(action: {
                        // Navigate to Edit Profile
                    }) {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .underline()
                    }
                    Spacer()
                }

                Picker("", selection: $selectedSegment) {
                    ForEach(MyPageSegment.allCases, id: \.self) { segment in
                        Text(segment.rawValue)
                            .tag(segment)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                Group {
                    switch selectedSegment {
                        case .posts:
                            VStack(spacing: 8) {
                                ForEach(breadPosts, id: \.bread.name) { viewModel in
                                    BakeryRankingCell(viewModel: viewModel)
                                }
                            }
                        case .favorites:
                            VStack(spacing: 8) {
                                ForEach(breadPosts, id: \.bread.name) { viewModel in
                                    BakeryRankingCell(viewModel: viewModel)
                                }
                                if breadPosts.isEmpty {
                                    Text("No favorites yet.")
                                        .foregroundColor(.gray)
                                        .padding()
                                }
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
            .padding(.horizontal)
        }
        .background(Color.creme.ignoresSafeArea())
        .navigationTitle("My Page")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MyPageView()
}

//
//  BakeryDetailView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

struct BakeryDetailView: View {
    @ObservedObject private var viewModel: BakeryDetailViewModel

    init(viewModel: BakeryDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.bakery.name)
                .font(.title)

            Text("\(viewModel.bakery.openingDays.map(\.rawValue).joined(separator: ", ")) \(viewModel.bakery.openAt.formatted) ~ \(viewModel.bakery.closeAt.formatted)")
                .font(.subheadline)

            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(viewModel.averageBreadRating) ? "star.fill" : (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0 ? "star.leadinghalf.filled" : "star"))
                        .foregroundColor(index < Int(viewModel.averageBreadRating) || (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0) ? .yellow : .gray)
                }
                Text(String(format: "%.1f", viewModel.averageBreadRating))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text("Photos")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.darkBlue)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(viewModel.breadPhotos) { photo in
                            AsyncImage(url: photo.imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 150)
                                    .clipped()
                                    .cornerRadius(8)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 200, height: 150)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .background(Color.skyBlue)
            }
            .cornerRadius(8)
            .padding()

            Text("Rankings")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.darkBlue)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.bakeryRankingCellViewModels
                        .sorted { cellViewModel1, cellViewModel2 in
                            return cellViewModel1.averageRating > cellViewModel2.averageRating
                        }
                    ) { cellViewModel in
                        BakeryRankingCell(viewModel: cellViewModel)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                    }
                }
            }
            .background(Color.clear)

            Button(action: {
                viewModel.showBakeryPostScreen()
            }) {
                Text("Post")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.darkPink)
                    .cornerRadius(8)
            }
            .padding()
        }
        .background(Color.creme.ignoresSafeArea())
    }
}

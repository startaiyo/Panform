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
        VStack {
            Text(viewModel.bakery.name)
                .font(.title)
                .padding()

            Text("\(viewModel.bakery.openingDays.map(\.rawValue).joined(separator: ", ")) \(viewModel.bakery.openAt.formatted) ~ \(viewModel.bakery.closeAt.formatted)")
                .font(.subheadline)
                .padding()

            HStack(spacing: 4) {
                ForEach(0..<5) { index in
                    Image(systemName: index < Int(viewModel.averageBreadRating) ? "star.fill" : (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0 ? "star.leadinghalf.filled" : "star"))
                        .foregroundColor(index < Int(viewModel.averageBreadRating) || (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0) ? .yellow : .gray)
                }
                Text(String(format: "%.1f", viewModel.averageBreadRating))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()

            HStack {
                Text(viewModel.bakery.memo)
                    .font(.body)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Spacer()
                Button(action: {
                    // TODO: Add edit action
                }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                .padding(.trailing)
            }
            .padding()

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
                // 2. Rankings List
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.breads.sorted { bread1, bread2 in
                        let bread1Rate = viewModel.breadReviews.filter { $0.breadID == bread1.id }.map(\.rate).first ?? 0
                        let bread2Rate = viewModel.breadReviews.filter { $0.breadID == bread2.id }.map(\.rate).first ?? 0
                        return bread1Rate > bread2Rate
                    }) { bread in
                        BakeryRankingCell(viewModel: BakeryRankingCellViewModel(
                            bread: bread,
                            reviews: viewModel.breadReviews
                        ))
                        .padding(.horizontal)
                        .padding(.vertical, 8) // Add some spacing if you want
                    }
                }
            }
            .background(Color.clear)

            HStack {
                Button(action: {
                    // TODO: Add save action
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.darkPink)
                        .cornerRadius(8)
                }

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
            }
            .padding()
        }
        .background(Color.creme.ignoresSafeArea())
    }
}

#Preview {
    BakeryDetailView(viewModel: BakeryDetailViewModel(bakery: .stub(),
                                                      breads: [BreadModel.stub(), BreadModel.stub()],
                                                      breadReviews: [BreadReviewModel.stub(), BreadReviewModel.stub()],
                                                      breadPhotos: [BreadPhotoModel.stub(), BreadPhotoModel.stub()],
                                                      didRequestToShowBakeryPost: {}))
}

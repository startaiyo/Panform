//
//  BakeryRankingCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/09.
//

import SwiftUI

struct BakeryRankingCell: View {
    @ObservedObject private var viewModel: BakeryRankingCellViewModel

    init(viewModel: BakeryRankingCellViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(viewModel.bread.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(viewModel.averageRating) ? "star.fill" :
                                (index < Int(viewModel.averageRating + 1) && viewModel.averageRating.truncatingRemainder(dividingBy: 1) > 0 ? "star.leadinghalf.filled" : "star"))
                            .foregroundColor(index < Int(viewModel.averageRating) || (index < Int(viewModel.averageRating + 1) && viewModel.averageRating.truncatingRemainder(dividingBy: 1) > 0) ? .yellow : .gray)
                    }
                    Text(String(format: "%.1f", viewModel.averageRating))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Button {
                        viewModel.saveButtonTapped()
                    } label: {
                        Image(systemName: viewModel.isSaved ? "bookmark.fill" : "bookmark")
                    }
                }
            }

            if viewModel.isSaved {
                TextField("memo", text: $viewModel.comment)
                    .font(.headline)
                    .foregroundColor(.white)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.vertical, 8)
            }

            Text("\(viewModel.bread.price) Yen")
                .font(.subheadline)
                .foregroundColor(.secondary)

            if let firstReview = viewModel.reviews.first {
                HStack(alignment: .top, spacing: 8) {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.white)
                        )

                    Text(firstReview.comment)
                        .font(.body)
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            } else {
                Text("No reviews yet.")
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.skyBlue)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

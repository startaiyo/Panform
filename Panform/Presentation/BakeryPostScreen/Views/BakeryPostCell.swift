//
//  BakeryPostCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/03/31.
//

import SwiftUI

struct BakeryPostCell: View {
    @ObservedObject var viewModel: BakeryPostCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let bread = viewModel.bread {
                HStack {
                    Text(bread.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    HStack(spacing: 8) {
                        Button(action: {
                            // Handle edit action
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button(action: {
                            // Handle delete action
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.darkBlue)
            }

            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Text("Score")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    HStack(spacing: 4) {
                        ForEach(0..<5) { index in
                            Image(systemName: index < Int(viewModel.averageRating) ? "star.fill" : (index < Int(viewModel.averageRating + 1) && viewModel.averageRating.truncatingRemainder(dividingBy: 1) > 0 ? "star.leadinghalf.filled" : "star"))
                                .foregroundColor(index < Int(viewModel.averageRating) || (index < Int(viewModel.averageRating + 1) && viewModel.averageRating.truncatingRemainder(dividingBy: 1) > 0) ? .yellow : .gray)
                        }
                        Text(String(format: "%.1f", viewModel.averageRating))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .fixedSize(horizontal: true, vertical: false)
                }
                

                HStack(alignment: .top) {
                    Text("Comment")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    Text(viewModel.reviewComment ?? "No review available")
                        .font(.body)
                        .multilineTextAlignment(.trailing)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.photos) { photo in
                            AsyncImage(url: photo.imageURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(8)
                            }
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

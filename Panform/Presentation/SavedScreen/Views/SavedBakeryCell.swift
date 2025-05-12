//
//  SavedBakeryCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/04/07.
//

import SwiftUI

struct SavedBakeryCell: View {
    @ObservedObject var viewModel: SavedBakeryCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title Section
            HStack {
                Text(viewModel.bakery.name)
                    .font(.headline)
                    .foregroundColor(.white)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.darkBlue)
            .onTapGesture {
                viewModel.showSavedBakeryScreen()
            }

            // Content Section
            HStack(alignment: .top, spacing: 12) {
                if let imageURL = viewModel.breadPhotos.first?.imageURL {
                    AsyncImage(url: imageURL) { image in
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

                VStack(alignment: .leading, spacing: 6) {
                    if let breadName = viewModel.breads.first?.name {
                        Text(breadName)
                            .font(.headline)
                    }

                    if let breadPrice = viewModel.breads.first?.price {
                        Text(String(format: "¥%.0f", breadPrice))
                            .font(.subheadline)
                    }

                    Text(viewModel.breadReviews.first?.comment ?? "No comment")
                        .font(.body)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                }

                Spacer()
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


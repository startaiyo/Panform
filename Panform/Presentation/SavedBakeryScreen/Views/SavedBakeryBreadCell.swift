//
//  SavedBakeryBreadCell.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import SwiftUI

struct SavedBakeryBreadCell : View {
    @ObservedObject var viewModel: SavedBakeryBreadCellViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(viewModel.bread.name)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.darkBlue)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Price")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    Text("\(viewModel.bread.price) Yen")
                        .font(.headline)
                }

                HStack(alignment: .top) {
                    Text("Comment")
                        .font(.subheadline)
                        .bold()

                    Spacer()

                    Text(viewModel.savedBread.comment)
                        .font(.body)
                        .multilineTextAlignment(.trailing)
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

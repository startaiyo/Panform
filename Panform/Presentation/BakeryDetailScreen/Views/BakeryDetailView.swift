//
//  BakeryDetailView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/07.
//

import SwiftUI

struct BakeryDetailView: View {
    @ObservedObject private var viewModel: BakeryDetailViewModel

    @State private var isEditing = false
    @State private var selectedOpenTime = Date()
    @State private var selectedCloseTime = Date()
    @State private var selectedDays: Set<WeekDay> = []

    init(viewModel: BakeryDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.bakery?.name ?? viewModel.place.name)
                .font(.title)

            if viewModel.bakery != nil {
                Button(action: {
                    if isEditing {
                        viewModel.updateBakeryData(open: selectedOpenTime,
                                                   close: selectedCloseTime,
                                                   openingDays: Array(selectedDays))
                    } else {
                        if let bakery = viewModel.bakery {
                            selectedOpenTime = bakery.openAt?.toDate() ?? Date()
                            selectedCloseTime = bakery.closeAt?.toDate() ?? Date()
                            selectedDays = Set(bakery.openingDays ?? [])
                        }
                    }
                    isEditing.toggle()
                }) {
                    if isEditing {
                        Text("Save the info")
                    } else {
                        HStack {
                            Text("Edit the info")
                            Image(systemName: "pencil")
                        }
                        .font(.subheadline)
                    }
                }

                // Editing UI
                if isEditing {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Opening hours")
                            .font(.subheadline)
                            .bold()

                        HStack {
                            DatePicker("OpenAt", selection: $selectedOpenTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                            Text("~")
                            DatePicker("CloseAt", selection: $selectedCloseTime, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                        }

                        Text("WeedDay")
                            .font(.subheadline)
                            .bold()

                        WeekdayPicker(selectedDays: $selectedDays)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }

            if let bakery = viewModel.bakery {
                HStack {
                    if bakery.openingDays?.isEmpty == false {
                        Text("\(bakery.openingDays!.map(\.rawValue).joined(separator: ", "))")
                            .font(.subheadline)
                    }
                    if let openAt = bakery.openAt,
                       let closeAt = bakery.closeAt {
                        Text("\(openAt.formatted) ~ \(closeAt.formatted)")
                    }
                }

                HStack(spacing: 4) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < Int(viewModel.averageBreadRating) ? "star.fill" : (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0 ? "star.leadinghalf.filled" : "star"))
                            .foregroundColor(index < Int(viewModel.averageBreadRating) || (index < Int(viewModel.averageBreadRating + 1) && viewModel.averageBreadRating.truncatingRemainder(dividingBy: 1) > 0) ? .yellow : .gray)
                    }
                    Text(String(format: "%.1f", viewModel.averageBreadRating))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()

                VStack(alignment: .leading) {
                    Text("Photos")
                        .font(.subheadline)
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
                                        .frame(width: 150, height: 100)
                                        .clipped()
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 150, height: 100)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .background(Color.skyBlue)
                }

                Spacer()

                Text("Rankings")
                    .font(.subheadline)
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
            } else {
                Spacer()
                Text("No reviews")
                Spacer()
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
            .padding()
        }
        .background(Color.creme.ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
        .onAppear {
            viewModel.reload()
        }
    }
}

struct WeekdayPicker: View {
    @Binding var selectedDays: Set<WeekDay>

    var body: some View {
        HStack {
            ForEach(WeekDay.allCases, id: \.self) { day in
                Button(action: {
                    if selectedDays.contains(day) {
                        selectedDays.remove(day)
                    } else {
                        selectedDays.insert(day)
                    }
                }) {
                    Text(day.rawValue)
                        .font(.system(size: 12))
                        .frame(width: 32)
                        .background(selectedDays.contains(day) ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(selectedDays.contains(day) ? .white : .black)
                        .cornerRadius(4)
                }
            }
        }
    }
}

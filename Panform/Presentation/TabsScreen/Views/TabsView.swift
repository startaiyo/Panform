//
//  TabsView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

struct TabsView: View {
    @ObservedObject private var viewModel: TabsViewModel

    init(viewModel: TabsViewModel) {
        self.viewModel = viewModel

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .skyBlue
        appearance.shadowColor = .clear
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .white

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .skyBlue
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }

    var body: some View {
        NavigationView {
            TabView {
                SearchView(viewModel: viewModel.searchViewModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                SavedView(viewModel: viewModel.savedViewModel)
                    .tabItem {
                        Image(systemName: "bookmark.fill")
                        Text("Saved")
                    }
                MyPageView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("MyPage")
                    }
            }
            .accentColor(.darkPink)
            .navigationTitle("Panform")
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
    }
}

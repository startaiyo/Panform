//
//  TabsView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/01/31.
//

import SwiftUI

struct TabsView: View {
    enum Tab {
        case search, saved, myPage
    }

    @ObservedObject private var viewModel: TabsViewModel
    @State private var selectedTab: Tab = .search

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
        TabView(selection: $selectedTab) {
            NavigationStack {
                SearchView(viewModel: viewModel.searchViewModel)
                    .navigationTitle("Panform")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .tag(Tab.search)

            NavigationStack {
                SavedView(viewModel: viewModel.savedViewModel)
                    .navigationTitle("Panform")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "bookmark.fill")
                Text("Saved")
            }
            .tag(Tab.saved)

            NavigationStack {
                MyPageView(viewModel: viewModel.myPageViewModel)
                    .navigationTitle("Panform")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("MyPage")
            }
            .tag(Tab.myPage)
        }
        .accentColor(.darkPink)
        .onChange(of: selectedTab) { newTab in
            switch newTab {
            case .search:
                viewModel.searchViewModel.reload()
            case .saved:
                viewModel.savedViewModel.reload()
            case .myPage:
                viewModel.myPageViewModel.reload()
            }
        }
    }
}

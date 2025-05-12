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
        NavigationView {
            TabView(selection: $selectedTab) {
                SearchView(viewModel: viewModel.searchViewModel)
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                    }
                    .tag(Tab.search)
                SavedView(viewModel: viewModel.savedViewModel)
                    .tabItem {
                        Image(systemName: "bookmark.fill")
                        Text("Saved")
                    }
                    .tag(Tab.saved)
                MyPageView(viewModel: viewModel.myPageViewModel)
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("MyPage")
                    }
                    .tag(Tab.myPage)
            }
            .accentColor(.darkPink)
            .navigationTitle("Panform")
            .navigationBarTitleDisplayMode(.inline)
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
        .navigationBarBackButtonHidden(true)
    }
}

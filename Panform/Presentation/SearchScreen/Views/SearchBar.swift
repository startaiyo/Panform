//
//  SearchBar.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/02.
//

import SwiftUI

struct SearchBar: UIViewRepresentable {
    @State var text: String = ""
    var onSearchButtonClicked: ((String) -> Void)?

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: SearchBar

        init(_ parent: SearchBar) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            parent.onSearchButtonClicked?(parent.text)
            searchBar.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search location"

        searchBar.barTintColor = .skyBlue
        searchBar.backgroundColor = .skyBlue
        searchBar.searchTextField.backgroundColor = .systemGray6
        searchBar.backgroundImage = UIImage()

        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
}

//
//  MapView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/02.
//

import GoogleMaps
import SwiftUI

struct MapView: UIViewRepresentable {
    typealias UIViewType = GMSMapView

    let mapView = GMSMapView()
    @Binding var searchQuery: String

    func makeUIView(context: Context) -> GMSMapView {
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if !searchQuery.isEmpty {
            print(searchQuery)
//            searchLocation(query: searchQuery)
        }
    }

    func searchLocation(query: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { placemarks, error in
            guard let location = placemarks?.first?.location else { return }
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 14)
            mapView.animate(to: camera)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
    }
}

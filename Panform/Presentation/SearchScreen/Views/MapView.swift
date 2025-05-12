//
//  MapView.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/02/02.
//

import SwiftUI
import GoogleMaps
import CoreLocation

struct MapView: UIViewRepresentable {
    typealias UIViewType = GMSMapView

    let mapView = GMSMapView()
    @Binding var searchQuery: String
    @Binding var bakeries: [BakeryModel]
    let onTap: (BakeryModel) -> Void

    func makeUIView(context: Context) -> GMSMapView {
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if !searchQuery.isEmpty {
            searchLocation(query: searchQuery, mapView: uiView)
        }
        if !context.coordinator.didMoveToFirstBakery,
           let firstBakery = bakeries.first {
            let camera = GMSCameraPosition.camera(
                withLatitude: firstBakery.location.coordinate.latitude,
                longitude: firstBakery.location.coordinate.longitude,
                zoom: 14
            )
            uiView.camera = camera
            context.coordinator.didMoveToFirstBakery = true
        }
        context.coordinator.updateMarkers(on: uiView, with: bakeries)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // MARK: - Search
    func searchLocation(query: String, mapView: GMSMapView) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { placemarks, error in
            guard let location = placemarks?.first?.location else { return }
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: 1)
            mapView.animate(to: camera)
        }
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: MapView
        var bakeryMap: [GMSMarker: BakeryModel] = [:]
        var didMoveToFirstBakery = false
        var existingBakeryIDs: Set<BakeryID> = []

        init(_ parent: MapView) {
            self.parent = parent
        }

        func updateMarkers(on mapView: GMSMapView, with bakeries: [BakeryModel]) {
            let newIDs = Set(bakeries.map { $0.id })
            if newIDs == existingBakeryIDs { return }

            // Remove all existing markers
            for marker in bakeryMap.keys {
                marker.map = nil
            }
            bakeryMap.removeAll()
            existingBakeryIDs = newIDs

            for bakery in bakeries {
                let marker = GMSMarker(position: bakery.location.coordinate)
                marker.title = bakery.name
                marker.snippet = bakery.memo
                marker.icon = GMSMarker.markerImage(with: .cyan)
                marker.map = mapView
                bakeryMap[marker] = bakery
            }
        }

        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            if let bakery = bakeryMap[marker] {
                parent.onTap(bakery)
            }
        }
    }
}

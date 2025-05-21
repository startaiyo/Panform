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
    @State var places: [Place] = []
    @Binding var bakeries: [BakeryModel]
    let onTap: (Place, BakeryModel?) -> Void
    let client = GooglePlacesAPIClient(apiKey: Secrets.googleMapApiKey)

    func makeUIView(context: Context) -> GMSMapView {
        mapView.delegate = context.coordinator
        mapView.isMyLocationEnabled = true
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        if !searchQuery.isEmpty && context.coordinator.lastSearchedQuery != searchQuery {
            context.coordinator.lastSearchedQuery = searchQuery
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
        context.coordinator.updateMarkers(on: uiView, with: places, andBakeries: bakeries)
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    // MARK: - Search
    func searchLocation(query: String, mapView: GMSMapView) {
        Task {
            let result = try await client.searchBakery(query: query)
            DispatchQueue.main.async {
                self.places = result
            }
            if let location = result.first?.geometry?.location {
                let camera = GMSCameraPosition.camera(withLatitude: location.lat,
                                                      longitude: location.lng,
                                                      zoom: 14)
                mapView.animate(to: camera)
            }
        }
    }

    // MARK: - Coordinator
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: MapView
        var bakeryMap: [GMSMarker: BakeryModel] = [:]
        var didMoveToFirstBakery = false
        var existingBakeryIDs: Set<BakeryID> = []
        var placeMap: [GMSMarker: Place] = [:]
        var existingPlaceKeys: Set<String> = []
        var lastSearchedQuery: String = ""

        init(_ parent: MapView) {
            self.parent = parent
        }

        func updateMarkers(on mapView: GMSMapView, with places: [Place], andBakeries bakeries: [BakeryModel]) {
            // Create a unique key for each place (e.g., name + address)
            let newPlaceKeys = Set(places.map { $0.name + ($0.formattedAddress ?? "") })
            let newBakeryIDs = Set(bakeries.map { $0.id })
            if newPlaceKeys == existingPlaceKeys && newBakeryIDs == existingBakeryIDs {
                return
            }

            // Remove all existing markers
            for marker in placeMap.keys {
                marker.map = nil
            }
            placeMap.removeAll()
            bakeryMap.removeAll()
            existingPlaceKeys = newPlaceKeys
            existingBakeryIDs = newBakeryIDs

            // Add new markers
            for place in places {
                guard let lat = place.geometry?.location.lat,
                      let lng = place.geometry?.location.lng else {
                    continue
                }

                let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: lng))
                marker.title = place.name
                marker.snippet = place.formattedAddress
                if let bakery = bakeries.first(where: { $0.placeID == place.placeID }) {
                    bakeryMap[marker] = bakery
                    marker.icon = GMSMarker.markerImage(with: .red)
                } else {
                    marker.icon = GMSMarker.markerImage(with: .cyan)
                }

                marker.map = mapView
                placeMap[marker] = place
            }
        }

        func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
            if let place = placeMap[marker] {
                parent.onTap(place, bakeryMap[marker])
            }
        }
    }
}

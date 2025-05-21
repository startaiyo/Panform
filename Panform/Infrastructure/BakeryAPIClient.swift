//
//  BakeryAPIClient.swift
//  Panform
//
//  Created by Shotaro Doi on 2025/05/12.
//

import Foundation

struct GooglePlacesAPIClient {
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    let apiKey: String

    func searchBakery(query: String) async throws -> [Place] {
        guard var components = URLComponents(string: "https://maps.googleapis.com/maps/api/place/textsearch/json") else {
            throw APIError.invalidURL
        }

        components.queryItems = [
            URLQueryItem(name: "query", value: "\(query) パン屋"),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "language", value: "ja")
        ]

        guard let url = components.url else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        try validate(response: response, data: data)

        let result = try decoder.decode(PlacesSearchResponse.self, from: data)
        return result.results
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
    }

    enum APIError: Error {
        case invalidURL
        case httpError(Int)
        case unknown
    }
}

struct PlacesSearchResponse: Decodable {
    let results: [Place]
}

struct Place: Decodable {
    let placeID: String
    let name: String
    let formattedAddress: String?
    let geometry: Geometry?
    
    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case name
        case formattedAddress = "formatted_address"
        case geometry
    }
}

struct Geometry: Decodable {
    let location: Location
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
}

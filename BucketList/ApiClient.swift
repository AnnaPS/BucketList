//
//  ApiClient.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import Foundation

class ApiClient {
    private let scheme = "https"
    private let host = "en.wikipedia.org"
    private let path = "/w/api.php"

    func getNearbyPlaces(lat: Double, long: Double) async -> [Page] {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "ggscoord", value: "\(lat)|\(long)"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "coordinates|pageimages|pageterms"),
            URLQueryItem(name: "colimit", value: "50"),
            URLQueryItem(name: "piprop", value: "thumbnail"),
            URLQueryItem(name: "pithumbsize", value: "500"),
            URLQueryItem(name: "pilimit", value: "50"),
            URLQueryItem(name: "wbptterms", value: "description"),
            URLQueryItem(name: "generator", value: "geosearch"),
            URLQueryItem(name: "ggsradius", value: "10000"),
            URLQueryItem(name: "ggslimit", value: "50"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components.url else {
            print("Invalid URL from components.")
            return []
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(Result.self, from: data)
            return items.query.pages.values.sorted()
        } catch {
            print("Error fetching or decoding data: \(error.localizedDescription)")
            return []
        }
    }
}

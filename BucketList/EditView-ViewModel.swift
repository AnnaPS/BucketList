//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import Foundation

enum LoadingState {
    case loading, loaded, failed
}

extension EditView {
    @Observable
    class ViewModel {
        private(set) var location: Location

        var name: String
        var description: String
        var latitude: Double
        var longitude: Double

        var loadingState = LoadingState.loading
        var pages = [Page]()

        private var onSave: (Location) -> Void
        private let apiClient: ApiClient

        init(location: Location, onSave: @escaping (Location) -> Void, apiClient: ApiClient = ApiClient()) {
            self.location = location
            self.name = location.name
            self.description = location.description
            self.latitude = location.latitude
            self.longitude = location.longitude
            self.onSave = onSave
            self.apiClient = apiClient
        }

        func save() {
            let updatedLocation = Location(
                id: UUID(),
                name: name,
                description: description,
                latitude: latitude,
                longitude: longitude
            )

            onSave(updatedLocation)
        }

        func fetchNearbyPlaces() async {
            loadingState = .loading
            let result = await apiClient.getNearbyPlaces(lat: location.latitude, long: location.longitude)

            if result.isEmpty {
                loadingState = .failed
            } else {
                pages = result
                loadingState = .loaded
            }
        }
    }
}

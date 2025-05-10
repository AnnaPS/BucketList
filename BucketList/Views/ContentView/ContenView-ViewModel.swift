//
//  ContenView-ViewModel.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import CoreLocation
import Foundation
import LocalAuthentication
import MapKit

// The view model for the content view.
// Adding this to an extension will avoid strange names for view models
// and allow it to be used only where needed.
extension ContentView {
    @Observable
    class ViewModel {
        private(set) var locations: [Location]
        var selectedPlace: Location?
        let storage = LocalStorage<[Location]>(fileName: "SavedPlaces")
        var isUnlocked = false

        init() {
            locations = storage.load() ?? []
        }

        func save() {
            storage.save(locations)
        }

        func addLocation(at point: CLLocationCoordinate2D) {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: point.latitude, longitude: point.longitude)

            locations.append(newLocation)
            save()
        }

        func update(location: Location) {
            guard let selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }

        func delete(_ location: Location) {
            locations.removeAll { $0.id == location.id }
            save()
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please, authenticate yourself to unlock your places"

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
                    if success {
                        self.isUnlocked = true
                    } else {
                        self.isUnlocked = false
                    }
                }
            } else {
                // no biometrics. Maybe touchID?
            }
        }
    }
}

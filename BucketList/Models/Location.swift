//
//  Location.swift
//  BucketList
//
//  Created by Ana Polo  on 2/5/25.
//

import Foundation
import MapKit

struct Location: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    // This won't be in the app store release
    #if DEBUG
    static let example = Location(name: "Buckingham Palace", description: "Lit by over 40,000 lightbulbs", latitude: 51.501, longitude: -0.141)
    #endif

    // Method to compare if a Location object is equal to another Location object
    // lhs = left hand side, rhs = right hand side
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}

//
//  Result.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    // dictionary of a string : list of string
    let terms: [String: [String]]?

    var description: String {
        terms?["description"]?.first ?? "No description available"
    }

    // needed for the Comparable Protocol
    // This will sort the pages by title
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}

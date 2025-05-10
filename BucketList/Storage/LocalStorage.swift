//
//  LocalStorage.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import Foundation

class LocalStorage<T: Codable> {
    private let fileName: String

    init(fileName: String) {
        self.fileName = fileName
    }

    private var fileURL: URL {
        URL.documentsDirectory.appending(path: fileName)
    }

    func save(_ data: T) {
        do {
            let encoded = try JSONEncoder().encode(data)
            try encoded.write(to: fileURL, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving \(fileName): \(error.localizedDescription)")
        }
    }

    func load() -> T? {
        do {
            let data = try Data(contentsOf: fileURL)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error loading \(fileName): \(error.localizedDescription)")
            return nil
        }
    }

    func delete() {
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print("Error deleting \(fileName): \(error.localizedDescription)")
        }
    }
}

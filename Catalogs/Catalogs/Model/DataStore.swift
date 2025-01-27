//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

class DataStore {
    let storeName: String
    let storeType = "json"
    
    let decoder = JSONDecoder()
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    var bundle: Bundle
        
    init(storeName: String, bundle: Bundle = Bundle.main) {
        self.storeName = storeName
        self.bundle = bundle
        copyDemoFileIfNecessary()
    }
}

// MARK: - Filesystem Access
extension DataStore {
    
    var demoFileURL: URL {
        Bundle.main.url(forResource: storeName, withExtension: storeType)!
    }
    
    var storeFileURL: URL {
        URL.documentsDirectory
            .appendingPathComponent(storeName)
            .appendingPathExtension(storeType)
    }
    
    private func copyDemoFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: storeFileURL.path) {
            try? FileManager.default.copyItem(at: demoFileURL, to: storeFileURL)
        }
    }
}

// MARK: - Persistence Operations
extension DataStore {
    
    enum StoreError: Error {
        case unableToEncode(message: String)
        case unableToDecode(message: String)
        case unableToSave(message: String)
    }

    func fetchBookCatalog() async throws -> BookCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileURL)
        return try decoder.decode(BookCatalog.self, from: data)
    }
    
    func fetchSpatialObjectCatalog() async throws -> SpatialObjectCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileURL)
        return try decoder.decode(SpatialObjectCatalog.self, from: data)
    }
    
    func save(bookCatalog: BookCatalog) throws {
        Task.detached {
            guard let data = try? self.encoder.encode(bookCatalog) else {
                throw StoreError.unableToEncode(message: "Unable to encode \(bookCatalog)")
            }
            
            do {
                try data.write(to: self.demoFileURL)
            } catch {
                throw StoreError.unableToSave(message: "Unable to write to \(self.demoFileURL), error was \(error)")
            }
        }
    }
}

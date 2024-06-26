//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import Foundation

enum StoreError: Error {
    case unableToEncode(message: String)
    case unableToDecode(message: String)
    case unableToSave(message: String)
}

class DataStore {
    let storeName: String
    let storeType = "json"
    
    let codableType = BookCatalog.self

    let decoder = JSONDecoder()
    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    var bundle: Bundle
    
    var documentsDirectoryUrl: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    var storeFileUrl: URL {
        documentsDirectoryUrl.appendingPathComponent(storeName).appendingPathExtension(storeType)
    }
    var templateStoreFileUrl: URL {
        bundle.url(forResource: storeName, withExtension: storeType)!
    }
    
    init(storeName: String, bundle: Bundle = Bundle.main) {
        self.storeName = storeName
        self.bundle = bundle
        copyStoreFileIfNecessary()
    }
    
    func copyStoreFileIfNecessary() {
        if !FileManager.default.fileExists(atPath: storeFileUrl.path) {
            try! FileManager.default.copyItem(at: templateStoreFileUrl, to: storeFileUrl)
        }
    }
    
    @MainActor func fetchBookCatalog() async throws -> BookCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileUrl)
        return try JSONDecoder().decode(BookCatalog.self, from: data)
    }
    
    @MainActor func fetchSpatialObjectCatalog() async throws -> SpatialObjectCatalog {
        let (data, _) = try await URLSession.shared.data(from: storeFileUrl)
        return try JSONDecoder().decode(SpatialObjectCatalog.self, from: data)
    }
    
    func save(bookCatalog: BookCatalog) throws {
        Task.detached {
            guard let data = try? self.encoder.encode(bookCatalog) else {
                throw StoreError.unableToEncode(message: "Unable to encode \(bookCatalog)")
            }
            
            do {
                try data.write(to: self.storeFileUrl)
            } catch {
                throw StoreError.unableToSave(message: "Unable to write to \(self.storeFileUrl), error was \(error)")
            }
        }
    }
}


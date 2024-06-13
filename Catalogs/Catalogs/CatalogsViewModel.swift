//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

enum Tab: String {
    case books = "Books"
    case objects = "3D Models"
    case settings = "Settings"
}

enum PresentationStyle {
    case list
    case grid
}

@Observable final class CatalogsViewModel {
    private static let booksStoreName = "BookCatalog"
    private let booksDataStore: DataStore
    private(set) var bookCatalog: BookCatalog
    
    private static let objectsStoreName = "ObjectCatalog"
    private let objectsDataStore: DataStore
    private(set) var objectCatalog: SpatialObjectCatalog
    
    var presentationStyle = PresentationStyle.list
    var selectedTab = Tab.books
    
    var booksCount: Int { bookCatalog.books.count }
    var objectsCount: Int { objectCatalog.objects.count }
    
    init(
        booksDataStore: DataStore = DataStore(storeName: booksStoreName),
        objectsDataStore: DataStore = DataStore(storeName: objectsStoreName)
    ) {
        self.booksDataStore = booksDataStore
        self.bookCatalog = BookCatalog(title: "Empty", books: [])
        
        self.objectsDataStore = objectsDataStore
        self.objectCatalog = SpatialObjectCatalog(title: "Empty", objects: [])
    }
}


// MARK: Actions
extension CatalogsViewModel {
    
    @MainActor func loadBooks() {
        guard bookCatalog.books.isEmpty else { return }
        
        Task {
            do {
                bookCatalog = try await booksDataStore.fetchBookCatalog()
            } catch {
                print("Unable to fetch BookCatalog from \(booksDataStore) due to \(error)")
            }
        }
    }
    
    func removeBooks(atOffsets offsets: IndexSet) {
        bookCatalog.remove(atOffsets: offsets)
    }
    
    func moveBooks(atOffsets offsets: IndexSet, toOffset offset: Int) {
        bookCatalog.move(atOffsets: offsets, toOffset: offset)
    }

    @MainActor func loadObjects() {
        guard objectCatalog.objects.isEmpty else { return }
        
        Task {
            do {
                objectCatalog = try await objectsDataStore.fetchSpatialObjectCatalog()
            } catch {
                print("Unable to fetch SpatialObjectCatalog from \(objectsDataStore) due to \(error)")
            }
        }
    }
}

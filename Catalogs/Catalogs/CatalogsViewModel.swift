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
    private static let bookCatalogStoreName = "BookCatalog"
    private static let objectCatalogStoreName = "ObjectCatalog"
    
    private let bookCatalogDataStore: DataStore
    private let objectCatalogDataStore: DataStore
    
    private(set) var bookCatalog = BookCatalog(title: "Empty", books: [])
    private(set) var objectCatalog = SpatialObjectCatalog(title: "Empty", objects: [])

    var presentationStyle = PresentationStyle.list
    
    var selectedTab = Tab.books
    var selectedObject: SpatialObject?
    
    var isAddingBook = false
    var isShowingImmersiveSpace = false
    
    init(
        booksDataStore: DataStore = DataStore(storeName: bookCatalogStoreName),
        objectsDataStore: DataStore = DataStore(storeName: objectCatalogStoreName)
    ) {
        self.bookCatalogDataStore = booksDataStore
        self.objectCatalogDataStore = objectsDataStore
    }
}

// MARK: Convenience Accessors
extension CatalogsViewModel {
    
    var navigationTitle: String {
        selectedTab == .settings ? selectedTab.rawValue :
        selectedTab == .books ? bookCatalog.title : objectCatalog.title
    }
    
    var books: [Book] {
        bookCatalog.books
    }
    
    var objects: [SpatialObject] {
        objectCatalog.objects
    }
    
    var booksCount: Int {
        books.count
    }
    
    var objectsCount: Int {
        objects.count
    }
    
    var hasBooks: Bool {
        bookCatalog.hasBooks
    }
    
    var hasObjects: Bool {
        objectCatalog.hasObjects
    }
}


// MARK: Actions
extension CatalogsViewModel {
    
    func loadBooks() {
        guard bookCatalog.books.isEmpty else { return }
        
        Task {
            do {
                bookCatalog = try await bookCatalogDataStore.fetchBookCatalog()
            } catch {
                print("Unable to fetch \(BookCatalog.self) from \(bookCatalogDataStore) due to \(error)")
            }
        }
    }
    
    func saveBooks() {
        try? bookCatalogDataStore.save(bookCatalog: bookCatalog)
    }
    
    func removeBooks(atOffsets offsets: IndexSet) {
        bookCatalog.remove(atOffsets: offsets)
        saveBooks()
    }
    
    func moveBooks(atOffsets offsets: IndexSet, toOffset offset: Int) {
        bookCatalog.move(fromOffsets: offsets, toOffset: offset)
        saveBooks()
    }
    
    func moveObjects(fromOffsets offsets: IndexSet, toOffset offset: Int) {
        objectCatalog.move(fromOffsets: offsets, toOffset: offset)
        saveBooks()
    }
    
    func addBook(_ book: Book) {
        isAddingBook = false
        bookCatalog.add(book: book)
        saveBooks()
    }
    
    func cancelAddBook() {
        isAddingBook = false
    }

    func loadObjects() {
        guard objectCatalog.objects.isEmpty else { return }
        
        Task {
            do {
                objectCatalog = try await objectCatalogDataStore.fetchSpatialObjectCatalog()
            } catch {
                print("Unable to fetch \(SpatialObjectCatalog.self) from \(objectCatalogDataStore) due to \(error)")
            }
        }
    }
}

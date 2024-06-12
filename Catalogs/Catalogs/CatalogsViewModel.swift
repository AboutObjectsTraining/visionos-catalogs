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

enum BookCatalogStyle {
    case list
    case grid
}

@Observable final class CatalogsViewModel {
    
    private let bookDataStore: BookDataStore
    
    var bookCatalog: BookCatalog
    
    var bookCatalogStyle = BookCatalogStyle.list
    var selectedTab = Tab.books
    
    var booksCount: Int { bookCatalog.books.count }
    
    init(bookDataStore: BookDataStore = BookDataStore()) {
        self.bookDataStore = bookDataStore
        self.bookCatalog = BookCatalog(title: "Empty", books: [])
    }
}


// MARK: Actions
extension CatalogsViewModel {
    
    @MainActor func loadBooks() {
        guard bookCatalog.books.isEmpty else { return }
        
        Task {
            do {
                bookCatalog = try await bookDataStore.fetchWithAsyncAwait()
            } catch {
                print("Unable to fetch BookCatalog from \(bookDataStore) due to \(error)")
            }
        }
    }
        
    func removeBooks(atOffsets indexSet: IndexSet) {
        bookCatalog.remove(atOffsets: indexSet)
    }
}

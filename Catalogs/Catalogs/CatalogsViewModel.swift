//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

@Observable final class CatalogsViewModel {
    
    private let bookDataStore: BookDataStore
    
    private(set) var bookCatalog: BookCatalog
    
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
}

//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookBrowser: View {
    @Bindable var viewModel: CatalogsViewModel
    
    var body: some View {
        VStack {
            // TODO: Add selection support to List
            List {
                ForEach(viewModel.bookCatalog.books) { book in
                    NavigationLink {
                        BookDetail(book: book)
                    } label: {
                        BookCell(book: book)
                    }
                }
            }
        }
        .onAppear { viewModel.loadBooks() }
    }
}

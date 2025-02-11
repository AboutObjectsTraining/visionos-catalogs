//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookCell: View {
    let book: Book
    
    private var bookInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(book.title)")
                .font(.headline)
            Text("\(book.year)  \(book.author)")
                .font(.subheadline)
        }
    }
    
    var body: some View {
        HStack {
            ThumbnailView(artworkUrl: book.artworkUrl, width: 70)
            bookInfo
            Spacer()
            ProgressView(value: book.percentComplete)
                .progressViewStyle(CompletionProgressViewStyle())
                .padding(.trailing, 12)
        }
    }
}

#Preview {
    BookCell(book: Book(title: "Something Awesome",
                        year: "1999",
                        author: "Fred Smith",
                        percentComplete: 0.7))
    .padding(30)
    .frame(width: 600)
    .glassBackgroundEffect()
}

#Preview("List", windowStyle: .automatic, traits: .fixedLayout(width: 600, height: 600)) {
    
    let viewModel = CatalogsViewModel()
    
    BookBrowser(viewModel: viewModel)
        .onAppear {
            if !viewModel.hasBooks {
                Task {
                    await viewModel.loadBooks()
                }
            }
        }
}

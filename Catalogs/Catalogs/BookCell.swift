//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookCell: View {
    let book: Book
    
    private var thumbnailPlaceholder: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(.secondary)
            Image(systemName: "photo")
                .foregroundColor(.white)
                .imageScale(.large)
        }
    }
    
    private var thumbnailView: some View {
        AsyncImage(url: book.artworkUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error == nil {
                ProgressView()
            } else {
                thumbnailPlaceholder
            }
        }
        .frame(width: 60, height: 90)
        .padding(.horizontal, 12)
    }
    
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
            thumbnailView
            bookInfo
            Spacer()
            ProgressView(value: book.percentComplete)
                .progressViewStyle(CompletionProgressViewStyle())
                .padding(.trailing, 12)
        }
    }
}

struct BookDetail: View {
    var book: Book
    
    var body: some View {
        Text("\(book.title)")
            .font(.headline)
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

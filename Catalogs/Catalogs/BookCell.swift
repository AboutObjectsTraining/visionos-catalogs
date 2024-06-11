//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookCell: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(book.title)")
                .font(.headline)
            Text("\(book.year)  \(book.author)")
                .font(.subheadline)
        }
        .padding(.vertical, 3)
    }
}

struct BookDetail: View {
    var book: Book
    
    var body: some View {
        Text("\(book.title)")
            .font(.headline)
    }
}

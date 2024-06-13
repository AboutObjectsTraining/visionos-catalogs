//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookDetail: View {
    var book: Book
    
    var body: some View {
        Text("\(book.title)")
            .font(.headline)
    }
}


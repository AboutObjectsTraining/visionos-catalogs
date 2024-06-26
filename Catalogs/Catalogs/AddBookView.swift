//
//  Created 6/26/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct AddBookView: View {

    @State var book = Book()
    @FocusState var isFocused: Bool
    
    var addBook: (Book) -> Void
    var cancel: () -> Void
    
    private var bookInfoSection: some View {
        Section (
            content: {
                Cell(prompt: "Title", text: $book.title)
                    .focused($isFocused)
                    .onAppear { isFocused = true }
                Cell(prompt: "Year", text: $book.year)
            },
            header: {
                Label("Book", systemImage: "book")
            }
        )
    }
    
    private var authorInfoSection: some View {
        Section (
            content: {
                Cell(prompt: "Name", text: $book.author)
            },
            header: {
                Label("Author", systemImage: "person")
            })
    }
    
    var body: some View {
        NavigationStack {
            Form {
                bookInfoSection
                authorInfoSection
            }
            .navigationTitle("Add Book")
            .interactiveDismissDisabled()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: cancel)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Done", action: { addBook(book) })
                }
            }
        }
    }
    
    struct Cell: View {
        var prompt: String
        @Binding var text: String
        
        var body: some View {
            TextField("Foo", text: $text, prompt: Text(prompt))
        }
    }
}

#if DEBUG
struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddBookView { _ in
                
            } cancel: { }
        }
        .previewDisplayName("Add Book View")
        NavigationStack {
            AddBookView { _ in
                
            } cancel: { }
        }
        .previewDisplayName("Add Book View Dark")
        .preferredColorScheme(.dark)
    }
}
#endif

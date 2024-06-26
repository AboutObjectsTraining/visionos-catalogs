//
//  Created 6/13/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct BookDetail: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.editMode) var editMode
    
    @Bindable var book: Book
    @State var viewModel: CatalogsViewModel
    @FocusState private var isFocused: Bool
    
    private var isEditing: Bool { editMode?.wrappedValue.isEditing ?? false }
    
    private var bookSection: some View {
        Section {
            TitledCell(title: "Title", value: $book.title)
                .focused($isFocused)
            TitledCell(title: "Year", value: $book.year)
        } header: {
            Label("Book", systemImage: "book")
        }
    }
    
    private var authorSection: some View {
        Section {
            TitledCell(title: "Name", value: $book.author)
        } header: {
            Label("Author", systemImage: "person")
        }
    }
    
    private var progressSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 6) {
                Text("Percent Complete")
                    .font(.caption)
                    .foregroundColor(.brown)
                
                Text(book.percentComplete, format: .percent)
                
                if isEditing {
                    Slider(value: $book.percentComplete,
                           in: 0.0...1.0,
                           step: 0.1,
                           label: { Text("Percent Complete") })
                }
            }
            .animation(.linear(duration: 0.15), value: isEditing)
        } header: {
            Label("Progress", systemImage: "chart.line.flattrend.xyaxis")
        }
    }
    
    private var hasShadow: Bool {
        colorScheme == .light && !isEditing
    }

    private var imageSection: some View {
        Section {
            HStack {
                Spacer()
                
                AsyncImage(url: book.artworkUrl) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Image(systemName: "photo")
                        .imageScale(.large)
                        .font(.system(size: 72))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        } header: {
            Label("Cover", systemImage: "book.closed")
        }
    }
    
    var body: some View {
        Form {
            bookSection
            authorSection
            progressSection
            imageSection
        }
        .navigationTitle("Book Detail")
        .toolbar {
            ToolbarItemGroup {
                EditButton()
            }
        }
        .onChange(of: isEditing) {
            isFocused = isEditing
            if !isEditing {
                viewModel.saveBooks()
                dismiss()
            }
        }
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        let book = Book(title: "My Book",
                        year: "1999", 
                        author: "Fred Smith")
        BookDetail(book: book, viewModel: CatalogsViewModel())
    }
}
#endif

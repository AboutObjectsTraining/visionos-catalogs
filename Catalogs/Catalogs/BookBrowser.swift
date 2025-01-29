//
//  Created 6/11/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//

import SwiftUI

struct BookBrowser: View {
    @Bindable var viewModel: CatalogsViewModel
    @AppStorage("shouldShowBooks") private var shouldShowBooks = true
    
    var bookList: some View {
        // TODO: Add selection support to List?
        List {
            ForEach(viewModel.books) { book in
                NavigationLink {
                    BookDetail(book: book, viewModel: viewModel)
                } label: {
                    BookCell(book: book)
                }
            }
            .onDelete { offsets in
                viewModel.removeBooks(atOffsets: offsets)
            }
            .onMove { offsets, targetOffset in
                viewModel.moveBooks(atOffsets: offsets, toOffset: targetOffset)
            }
        }
        .padding(.bottom, 24)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.navigationTitle)
        .toolbar {
            Text("\(viewModel.booksCount) items")
                .font(.headline)
                .fixedSize()
            Spacer()
            EditButton()
            Button(action: { viewModel.isAddingBook = true },
                   label: { Image.plus })
        }
    }
    
    var body: some View {
        NavigationStack {
            if !(viewModel.hasBooks && shouldShowBooks) {
                EmptyContentMessage(itemName: "book")
            } else {
                if viewModel.presentationStyle == .list {
                    bookList
                } else {
                    BookGrid(viewModel: viewModel)
                }
            }
        }
        .ornament(attachmentAnchor: .scene(.bottom), contentAlignment: .top) {
            HStack {
                Picker("", selection: $viewModel.presentationStyle) {
                    Text("List")
                        .tag(PresentationStyle.list)
                    Text("Grid")
                        .tag(PresentationStyle.grid)
                }
                .background(.thinMaterial, in: Capsule())
            }
            .padding(.horizontal, 12)
            .frame(width: 240, height: 72)
            .pickerStyle(.segmented)
            .glassBackgroundEffect()
        }
        .sheet(
            isPresented: $viewModel.isAddingBook,
            content: {
                AddBookView(addBook: viewModel.addBook(_:),
                            cancel: viewModel.cancelAddBook)
            }
        )
    }
}

struct BookGrid: View {
    var viewModel: CatalogsViewModel
    
    static let gridItems = [
        GridItem(.adaptive(minimum: 150, maximum: 220), spacing: 24, alignment: .top)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Self.gridItems) {
                    ForEach(viewModel.books) { book in
                        ZStack {
                            NavigationLink {
                                BookDetail(book: book, viewModel: viewModel)
                            } label: {
                                coverImage(book: book)
                            }
                            // super unintuitive setting here 🤦🏻‍♂️
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewModel.navigationTitle)
            .toolbar {
                Text("\(viewModel.booksCount) items")
                    .font(.headline)
                    .fixedSize()
                Spacer()
                Button(action: { viewModel.isAddingBook = true },
                       label: { Image.plus })
            }
        }
    }
    
    func coverImage(book: Book) -> some View {
        
        AsyncImage(url: book.artworkUrl) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                ThumbnailView.Placeholder()
                    .font(.largeTitle)
            } else {
                ProgressView()
            }
        }
    }
}

#Preview("List", windowStyle: .automatic, traits: .fixedLayout(width: 600, height: 800)) {
    let viewModel = CatalogsViewModel()
    ContentView(viewModel: viewModel)
}

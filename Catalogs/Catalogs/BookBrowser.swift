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
            ForEach(viewModel.bookCatalog.books) { book in
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
    }
    
    var noBooksMessage: some View {
        VStack {
            Spacer()
            Text("No Books")
                .font(.headline)
            Text("Tap the + button to add a book to the catalog.")
                .font(.subheadline)
            Spacer()
        }
    }
    
    var body: some View {
        VStack {
            if viewModel.bookCatalog.hasBooks, shouldShowBooks {
                if viewModel.presentationStyle == .list {
                    bookList
                } else {
                    BookGrid(viewModel: viewModel)
                }
            } else {
                noBooksMessage
            }
        }
        .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    if viewModel.selectedTab == .books {
                        Text("\(viewModel.booksCount) items")
                            .font(.headline)
                            .fixedSize()
                        Spacer()
                        if viewModel.presentationStyle == .list {
                            EditButton()
                        }
                        Button(action: { viewModel.isAddingBook = true },
                               label: { Image.plus })
                    }
                }
            //  ToolbarItem(placement: .bottomOrnament) {
            //      Picker("", selection: $viewModel.bookCatalogStyle) {
            //          Text("List")
            //              .tag(BookCatalogStyle.list)
            //          Text("Grid")
            //              .tag(BookCatalogStyle.grid)
            //      }
            //      .pickerStyle(.segmented)
            //      .background(Material.thin, in: Capsule())
            //      .frame(width: 240)
            //  }
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
        .onAppear {
            viewModel.loadBooks()
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
        ScrollView {
            LazyVGrid(columns: Self.gridItems) {
                ForEach(viewModel.bookCatalog.books) { book in
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

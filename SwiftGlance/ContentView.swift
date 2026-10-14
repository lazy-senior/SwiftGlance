//
//  ContentView.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: SortDescriptor(\.timestamp, ordering: .descending)) private var history: [Item]

    @State private var selection: Panel = .bookmarks
    @StateObject private var page = WebPage()

    var body: some View {
        HStack(spacing: 0) {
            IconSidebarView(selection: $selection)

            Group {
                switch selection {
                case .bookmarks:
                    BookmarkCollectionView(onOpen: { entry in
                        page.load(entry.url)
                        selection = .browser
                    })
                case .browser:
                    BrowseView(page: page)
                case .recent:
                    RecentView(history: history, onOpen: { url in
                        page.load(url)
                        selection = .browser
                    })
                case .manage:
                    BookmarkCollectionView(onOpen: { entry in
                        page.load(entry.url)
                        selection = .browser
                    })
                }
            }
            .frame(minWidth: 320, minHeight: 400)

            InfoPanel(page: page)
        }
        .onAppear {
            page.onDidFinishLoading = { title, url in
                modelContext.insert(Item(title: title, url: url.absoluteString))
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

//
//  BookmarkCollectionView.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct BookmarkEntry: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let url: URL
}

struct BookmarkCollectionView: View {
    @State private var entries: [BookmarkEntry] = []
    @State private var isShowingBookmarkImporter = false
    @State private var loadError: String?

    private let bookmarkRepository = BookmarkRepository()

    let onOpen: (BookmarkEntry) -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    isShowingBookmarkImporter = true
                } label: {
                    Label("Import Bookmarks", systemImage: "folder")
                }

                if let loadError {
                    Text(loadError)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                Spacer()
            }
            .padding()

            if entries.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("No bookmarks yet")
                        .font(.headline)
                    Text("Import your Safari Bookmarks.plist to get started.")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()
            } else {
                List(entries, id: \.id) { entry in
                    Button {
                        onOpen(entry)
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundStyle(.secondary)
                            Text(entry.title.isEmpty ? entry.url.absoluteString : entry.title)
                                .lineLimit(1)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .background(.regularMaterial)
        .task {
            loadBookmarks()
        }
        .fileImporter(isPresented: $isShowingBookmarkImporter, allowedContentTypes: [.propertyList]) { result in
            switch result {
            case .success(let url):
                loadBookmarks(from: url)
            case .failure(let error):
                loadError = error.localizedDescription
                NSLog("Failed to choose Safari bookmarks: \(error.localizedDescription)")
            }
        }
    }

    private func loadBookmarks(from url: URL? = nil) {
        NSLog("Loading Safari bookmarks")

        do {
            let loadedBookmarks: Dictionary<String, Any>
            if let url {
                loadedBookmarks = try bookmarkRepository.getSafariBookmarks(from: url)
            } else {
                loadedBookmarks = try bookmarkRepository.getSafariBookmarks()
            }

            entries = extractBookmarks(from: loadedBookmarks)
            loadError = nil
            NSLog("Loaded \(entries.count) Safari bookmarks")
        } catch {
            loadError = error.localizedDescription
            NSLog("Failed to load Safari bookmarks: \(error.localizedDescription)")
        }
    }

    private func extractBookmarks(from root: Dictionary<String, Any>) -> [BookmarkEntry] {
        var entries: [BookmarkEntry] = []

        if let children = root["Children"] as? [[String: Any]] {
            for child in children {
                extract(child, into: &entries)
            }
        }

        if let menu = root["Menu"] as? [String: Any] {
            extract(menu, into: &entries)
        }

        return entries.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
    }

    private func extract(_ node: Dictionary<String, Any>, into entries: inout [BookmarkEntry]) {
        if let children = node["Children"] as? [[String: Any]] {
            for child in children {
                extract(child, into: &entries)
            }
        }

        guard let urlString = node["URLString"] as? String, let url = URL(string: urlString) else {
            return
        }

        let title = (node["URIDictionary"] as? [String: String])?["title"] ?? urlString
        entries.append(BookmarkEntry(title: title, url: url))
    }
}

#Preview {
    BookmarkCollectionView(onOpen: { _ in })
}

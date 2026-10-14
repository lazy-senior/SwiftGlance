//
//  BookmarkRepository.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import Foundation

final class BookmarkRepository {
    
    private let homeDirURL = FileManager.default.homeDirectoryForCurrentUser
    private let workListPath = "Bookmarks.plist"
    private let sourceListURL: URL

    private let bookmarkManager = BookmarkManager()
    private var bookmarks: Dictionary<String,Any>
    
    init () {
        sourceListURL = homeDirURL
            .appendingPathComponent("Library", isDirectory: true)
            .appendingPathComponent("Safari", isDirectory: true)
            .appendingPathComponent("Bookmarks.plist", isDirectory: false)
        bookmarks = [:]
    }
    
    public func getSafariBookmarks() throws -> Dictionary<String, Any> {
        try load(from: sourceListURL)
        return bookmarks
    }

    public func getSafariBookmarks(from url: URL) throws -> Dictionary<String, Any> {
        let canAccess = url.startAccessingSecurityScopedResource()
        defer {
            if canAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        try load(from: url)
        return bookmarks
    }
    
    private func load(from url: URL) throws {
        let fileManager = FileManager.default
        let fileExists = fileManager.fileExists(atPath: url.path)
        let isReadable = fileManager.isReadableFile(atPath: url.path)

        NSLog("Safari bookmarks path: \(url.path)")
        NSLog("Safari bookmarks exists: \(fileExists), readable: \(isReadable)")

        guard let bookmarks = bookmarkManager.getPlist(withURL: url) else {
            throw "Could not read Safari bookmarks at \(url.path). Exists: \(fileExists), readable: \(isReadable). macOS privacy or sandboxing may be blocking access."
        }

        if !bookmarkManager.secureCopyItemAtPath(at: url.path, to: workListPath) {
            throw "Could not save backup copy at " + workListPath
        }

        self.bookmarks = bookmarks
    }
    public func add(bookmarkTitle: String, bookmarkURL: String, dest: String) throws {
        let updatedBookmarks = try bookmarkManager.addBookmark(withPlist: bookmarks, toFolder: dest, bookmarkTitle: bookmarkTitle, bookmarkURL: bookmarkURL)
        let encodableBookmarks = NSDictionary(dictionary: updatedBookmarks)
        encodableBookmarks.write(toFile: sourceListURL.path, atomically: true)
    }
    
    public func move(pattern: String, dest: String) throws{
        let updatedBookmarks = try bookmarkManager.moveBookmarksByPattern(withPlist: bookmarks, withPattern: pattern, toFolder: dest)
        let encodableBookmarks = NSDictionary(dictionary: updatedBookmarks)
        encodableBookmarks.write(toFile: sourceListURL.path, atomically: true)
    }
    
    public func remove(pattern: String) throws{
        let updatedBookmarks = try bookmarkManager.removeBookmarksByUrlOrTitle(withPlist: bookmarks, withPattern: pattern)
        print("Please confirm removal of all bookmarks matching pattern " + pattern + " in either title or URL")
        var ans = readLine()
        ans = ans!.lowercased()
        if (ans != "y" || ans != "yes") {
            print("Change was not confirmed - Exiting with no change made")
            exit(0)
        }
        let encodableBookmarks = NSDictionary(dictionary: updatedBookmarks)
        encodableBookmarks.write(toFile: sourceListURL.path, atomically: true)
    }
    
    public func search(pattern:String) -> [Dictionary<String,Any>]{
        let foundBookmarks = bookmarkManager.searchBookmarksByUrlOrTitle(withPlist: bookmarks, withPattern: pattern)
        return foundBookmarks;
//        for bookmark in foundBookmarks {
//            for bookmarkKey in [String](bookmark.keys).sorted() {
//                print(bookmarkKey)
//            }
//            exit(0)
//        }
    }
}

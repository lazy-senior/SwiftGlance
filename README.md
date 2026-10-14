# SwiftGlance

A macOS dashboard app built with SwiftUI and SwiftData. SwiftGlance gives you a
quick "glance" view of your Safari bookmarks, a lightweight in-app browser, and
a recently-visited history — all laid out in a single window with a left icon
rail, a central content panel, and a right details panel.

## Requirements

- Xcode 26+ (Swift 5)
- macOS 13+ (SwiftData)

## Running

Open `SwiftGlance.xcodeproj` in Xcode and press ▶ Run. The app targets macOS
(and is configured for iOS / watchOS / visionOS as well).

## Layout

The main window (`ContentView`) is a horizontal stack of three areas:

```
+-----------+------------------------+------------------+
| Icon rail |  Central content panel |  Details panel   |
| (Icon    |  (switches by selection)|  (InfoPanel)     |
| Sidebar) |                        |                  |
+-----------+------------------------+------------------+
```

## Views & Features

### Navigation — `IconSidebarView` + `Panel`
A vertical rail of icon buttons that switches the central panel. Selection is
tracked with the `Panel` enum:

- `bookmarks` — browse Safari bookmarks
- `browser` — the in-app web browser
- `recent` — recently visited pages
- `manage` — import/manage bookmarks (same view as bookmarks)

### Bookmarks — `BookmarkCollectionView`
Lists your Safari bookmarks. On appear it tries to read
`~/Library/Safari/Bookmarks.plist`; if the sandbox blocks that, click
**Import Bookmarks** to choose a `Bookmarks.plist` file.

- Flattens the Safari bookmark tree into a clickable list of leaf bookmarks.
- Opening a bookmark loads its URL in the browser panel.
- `BookmarkRepository` reads the plist and makes a backup copy before use.

### Browser — `BrowseView` + `WebPage` + `WebView`
A minimal web browser powered by `WebKit`.

- Address bar: type a full URL, a bare domain (e.g. `example.com`), or a search
  term (falls back to a Bing search).
- Loading spinner and lock/error indicator.
- Error overlay with a **Try Again** button.
- `WebPage` is the shared state holder (url, title, loading, error) and owns the
  underlying `WKWebView`.
- `WebView` is the `NSViewRepresentable` bridge to `WKWebView`.

### History — `Item` + `RecentView`
Each page that finishes loading is recorded as an `Item` (title, url, timestamp)
in SwiftData. The **Recent** panel (`RecentView`) shows the most recent pages
newest-first; opening one loads it in the browser.

### Details — `InfoPanel`
Shows details for the currently loaded page: title, URL, and load status
(loading / loaded / failed).

## Project structure

| File | Responsibility |
|------|----------------|
| `SwiftGlanceApp.swift` | App entry point and SwiftData model container |
| `ContentView.swift` | Orchestrates navigation, shared page state, and history |
| `Panel.swift` | Navigation section enum |
| `IconSidebarView.swift` | Navigation rail |
| `SidebarIconView.swift` | Single icon button (selection + badge) |
| `BookmarkCollectionView.swift` | Safari bookmark browser/importer |
| `BrowseView.swift` | In-app browser with address bar |
| `WebPage.swift` | Web state holder + `WKWebView` bridge |
| `InfoPanel.swift` | Current page details |
| `RecentView.swift` | Recently-visited history list |
| `Item.swift` | SwiftData model for visited pages |
| `Bookmark/BookmarkRepository.swift` | Reads/writes Safari `Bookmarks.plist` |
| `Bookmark/BookmarkManager.swift` | Bookmark tree manipulation helpers |

## Notes & limitations

- **Sandbox access**: reading `~/Library/Safari/Bookmarks.plist` directly may be
  blocked by the app sandbox. Use the **Import Bookmarks** button to grant
  read-only access to a specific file.
- The `Bookmark/` helpers were originally a command-line tool. They still contain
  interactive (`readLine`) and `exit()` calls that are not usable from the GUI;
  they are not wired into the UI.

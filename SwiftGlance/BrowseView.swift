//
//  BrowseView.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI
import WebKit

struct BrowseView: View {
    @ObservedObject var page: WebPage
    @State private var urlText: String = ""

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                if page.isLoading {
                    ProgressView().controlSize(.small)
                } else {
                    Image(systemName: page.error != nil ? "exclamationmark.triangle" : "lock.fill")
                        .foregroundStyle(page.error != nil ? .orange : .secondary)
                }

                TextField("Search or enter website address", text: $urlText)
                    .onSubmit(navigate)
                    .textFieldStyle(.roundedBorder)

                Button {
                    page.load(nil)
                } label: {
                    Image(systemName: "house")
                }
                .buttonStyle(.plain)
                .help("Home")

                if !page.title.isEmpty {
                    Text(page.title)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(10)
            .background(.thinMaterial)

            WebView(page: page)
                .overlay {
                    if let error = page.error {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(.orange)
                            Text("Could not load this page")
                                .font(.headline)
                            Text(error)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 420)
                            Button("Try Again") { navigate() }
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
        }
        .background(.regularMaterial)
        .onChange(of: page.url) { _, newValue in
            if let newValue {
                urlText = newValue.absoluteString
            }
        }
        .onAppear {
            if page.url == nil {
                urlText = "https://www.apple.com"
                page.load(URL(string: "https://www.apple.com"))
            }
        }
    }

    private func navigate() {
        if let url = resolve(urlText) {
            page.load(url)
        }
    }

    private func resolve(_ input: String) -> URL? {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return URL(string: "https://www.apple.com") }

        if let url = URL(string: trimmed), url.scheme != nil, url.host != nil {
            return url
        }

        if trimmed.contains(".") && !trimmed.contains(" ") {
            return URL(string: "https://\(trimmed)")
        }

        let query = trimmed.replacingOccurrences(of: " ", with: "+")
        return URL(string: "https://www.bing.com/search?q=\(query)")
    }
}

#Preview {
    BrowseView(page: WebPage())
        .defaultSize(width: 900, height: 600)
}

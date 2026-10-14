//
//  WebPage.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI
import WebKit

final class WebPage: ObservableObject {
    @Published var url: URL?
    @Published var title: String = ""
    @Published var isLoading: Bool = false
    @Published var error: String?

    var onDidFinishLoading: ((String, URL) -> Void)?

    private let webView: WKWebView

    init(configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        self.webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView.navigationDelegate = PageNavigationDelegate(page: self)
    }

    func load(_ url: URL?) {
        guard let url else { return }
        self.url = url
        self.error = nil
        self.isLoading = true
        self.title = url.host ?? url.absoluteString
        webView.load(URLRequest(url: url))
    }
}

struct WebView: NSViewRepresentable {
    @ObservedObject var page: WebPage

    func makeView(context: Context) -> WKWebView {
        page.webView
    }

    func updateView(_ webView: WKWebView, context: Context) {}
}

final class PageNavigationDelegate: NSObject, WKNavigationDelegate {
    let page: WebPage

    init(page: WebPage) {
        self.page = page
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        page.title = webView.title.isEmpty ? webView.url?.absoluteString ?? "" : webView.title
        page.isLoading = false
        page.onDidFinishLoading?(page.title, webView.url ?? URL(string: "about:blank")!)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        page.isLoading = false
        page.error = error.localizedDescription
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        page.isLoading = false
        page.error = error.localizedDescription
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        page.isLoading = true
    }
}

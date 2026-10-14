//
//  InfoPanel.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI

struct InfoPanel: View {
    @ObservedObject var page: WebPage

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: "info.circle.fill")
                Text("Details")
                    .font(.headline)
            }
            .font(.title3)

            Divider()

            if let url = page.url {
                detailRow(icon: "tag", label: "Title", value: page.title.isEmpty ? "—" : page.title)
                detailRow(icon: "link", label: "URL", value: url.absoluteString)
                detailRow(icon: statusIcon, label: "Status", value: statusText)
            } else {
                Text("Open a bookmark or navigate to a site to see its details here.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding()
        .frame(width: 300, alignment: .leading)
        .background(.ultraThinMaterial)
    }

    private var statusText: String {
        if page.isLoading { return "Loading…" }
        if page.error != nil { return "Failed" }
        return "Loaded"
    }

    private var statusIcon: String {
        if page.isLoading { return "arrow.triangle.2.circlepath" }
        if page.error != nil { return "xmark.circle" }
        return "checkmark.circle.fill"
    }

    @ViewBuilder
    private func detailRow(icon: String, label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                Text(label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(value)
                .font(.body)
                .lineLimit(2)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    InfoPanel(page: WebPage())
        .frame(width: 300)
}

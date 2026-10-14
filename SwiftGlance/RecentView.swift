//
//  RecentView.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import SwiftUI

struct RecentView: View {
    let history: [Item]
    let onOpen: (URL) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text("Recently Visited")
                .font(.headline)
                .padding()

            if history.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 48))
                        .foregroundStyle(.secondary)
                    Text("Pages you open will show up here.")
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                List(history) { item in
                    Button {
                        if let url = URL(string: item.url) {
                            onOpen(url)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundStyle(.secondary)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title.isEmpty ? item.url : item.title)
                                    .lineLimit(1)
                                Text(item.url)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
        }
        .background(.regularMaterial)
    }
}

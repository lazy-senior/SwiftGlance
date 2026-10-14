//
//  Item.swift
//  SwiftGlance
//
//  Created by Vinzenz Boening on 28.05.26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var title: String
    var url: String
    var timestamp: Date

    init(title: String, url: String, timestamp: Date = Date()) {
        self.title = title
        self.url = url
        self.timestamp = timestamp
    }
}

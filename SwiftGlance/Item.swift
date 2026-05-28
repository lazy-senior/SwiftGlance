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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

//
//  Item.swift
//  gembg
//
//  Created by Nipuna Chandimal on 2025-06-29.
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

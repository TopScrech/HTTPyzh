//
//  Item.swift
//  HTTPyzh
//
//  Created by Sergei Saliukov on 11/12/2023.
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

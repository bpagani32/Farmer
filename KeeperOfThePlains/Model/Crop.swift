//
//  Crop.swift
//  FarmersGuild
//
//  Created by Ivan Ramirez on 8/29/22.
//

import Foundation


struct Player {
    var score: Int
}

struct Crop: Codable, Equatable {
    var id: UUID = UUID()
    var textureName: String
    var cropStage: Int = 0
    var startTime: Date?
    var expirationTime: Date?
    
    static func == (lhs: Crop, rhs: Crop) -> Bool {
        lhs.id == rhs.id
    }
}

enum lemonTree: String {
    case lemon_tree_bear
    case lemon_tree_lemons
}

enum corn: String {
    case sweet_corn_0
    case sweet_corn_1
    case sweetcorn_group
}

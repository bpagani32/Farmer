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

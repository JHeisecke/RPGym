//
//  MuscleGroupElement.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import Foundation

// MARK: - MuscleGroup

struct MuscleGroup: Codable, Equatable {
    let id, name, imageURL: String
    let muscles: [String]

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
        case muscles
    }
}

typealias MuscleGroups = [MuscleGroup]

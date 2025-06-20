//
//  Muscle.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import Foundation

typealias Muscles = [Muscle]

// MARK: - Muscle

struct Muscle: Codable {
    let id, name, commonName, group: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case commonName = "common_name"
        case group
        case imageURL = "image_url"
    }
}

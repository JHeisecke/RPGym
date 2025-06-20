//
//  Exercise.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import Foundation

// MARK: - Exercise

struct Exercise: Codable {
    let id, name, description, generalInstructions: String
    let breathingTechnique: String?
    let steps: [String]?
    let targetedMuscles: [String]?
    let videoURL: String
    let imageUrls, variationIds: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case breathingTechnique = "breathing_technique"
        case generalInstructions = "general_instructions"
        case steps
        case targetedMuscles = "targeted_muscles"
        case videoURL = "video_url"
        case imageUrls = "image_urls"
        case variationIds = "variation_ids"
    }
}

struct Exercises: Codable {
    let exercises: [Exercise]

    enum CodingKeys: String, CodingKey {
        case exercises = "data"
    }
}

//
//  Exercise.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import Foundation

// MARK: - Exercise

struct Exercise: Codable, Hashable {
    let id, name, description: String
    let breathingTechnique: String?
    let generalInstructions: String
    let steps, primaryMuscles, secondaryMuscles, accessoryMuscles: [String]?
    let videoURL: String?
    let imageUrls, variationIDS: [String]

    var targetedMuscles: [String] {
        return (primaryMuscles ?? []) + (secondaryMuscles ?? []) + (accessoryMuscles ?? [])
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case breathingTechnique = "breathing_technique"
        case generalInstructions = "general_instructions"
        case steps
        case primaryMuscles = "primary_muscles"
        case secondaryMuscles = "secondary_muscles"
        case accessoryMuscles = "accessory_muscles"
        case videoURL = "video_url"
        case imageUrls = "image_urls"
        case variationIDS = "variation_ids"
    }
}

typealias Exercises = [Exercise]

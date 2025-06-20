//
//  AuthError.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import Foundation

enum ExerciseError: LocalizedError {
    case fileNotFound
    case dataReadError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            "Error: exercises.json not found in bundle."
        case .dataReadError(let error):
            "Error: Could not load data from exercises.json. \(error)"
        case .decodingError(let error):
            "Error: Failed to decode exercises.json. \(error)"
        }
    }
}

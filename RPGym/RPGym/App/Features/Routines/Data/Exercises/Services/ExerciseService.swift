//
//  ExerciseService.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-18.
//

import Foundation

protocol ExerciseService: Sendable {
    func fetchExercises() async throws -> Exercises
}

struct ExerciseServiceImpl: ExerciseService {

    func fetchExercises() async throws -> Exercises {
            guard let fileURL = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
                throw ExerciseError.fileNotFound
            }

            let data: Data
            do {
                data = try Data(contentsOf: fileURL)
            } catch {
                throw ExerciseError.dataReadError(error)
            }
            let decoder = JSONDecoder()
            do {
                let exercises = try decoder.decode(Exercises.self, from: data)
                return exercises
            } catch {
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let type, let context):
                        print("Type mismatch for type \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))\nDebug Description: \(context.debugDescription)")
                    case .valueNotFound(let type, let context):
                        print("Value not found for type \(type) at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))\nDebug Description: \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Key '\(key.stringValue)' not found at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))\nDebug Description: \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Data corrupted at path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))\nDebug Description: \(context.debugDescription)")
                    @unknown default:
                        print("Unknown decoding error: \(error.localizedDescription)")
                    }
                }
                throw ExerciseError.decodingError(error)
            }
        }
    }

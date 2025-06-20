//
//  FileReader.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import Foundation

protocol FileReaderService: Sendable {
    func read<T: Decodable>(from jsonFile: File) async throws -> T
}

// MARK: - Reader

struct FileReaderServiceImpl: FileReaderService {
    func read<T: Decodable>(from jsonFile: File) async throws -> T {
        guard let fileURL = Bundle.main.url(forResource: jsonFile.rawValue, withExtension: "json") else {
            throw FileReadingError.fileNotFound(file: jsonFile.rawValue)
        }

        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch {
            throw FileReadingError.dataReadError(file: jsonFile.rawValue, error)
        }
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
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
            throw FileReadingError.decodingError(file: jsonFile.rawValue, error)
        }
    }
}

// MARK: - File names

enum File: String {
    case exercises
    case muscles
    case muscle_groups
}

// MARK: - Error

enum FileReadingError: LocalizedError {
    case fileNotFound(file: String)
    case dataReadError(file: String, _ error: Error)
    case decodingError(file: String, _ error: Error)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let file):
            "Error: \(file).json not found in bundle."
        case .dataReadError(let file, let error):
            "Error: Could not load data from \(file).json. \(error)"
        case .decodingError(let file, let error):
            "Error: Failed to decode \(file).json. \(error)"
        }
    }
}

//
//  ExercisesManager.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import SwiftUI

@MainActor
class ExercisesManager: ObservableObject {
    private let service: FileReaderService
    private(set) var exercises: Exercises = []

    init(service: FileReaderService) {
        self.service = service
    }

    // MARK: - Services

    @discardableResult
    func fetchExercises() async throws -> Exercises {
        guard exercises.isEmpty else { return exercises }
        let result: Exercises = try await service.read(from: File.exercises)
        exercises = result
        return exercises
    }
}

//
//  ExercisesManager.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import SwiftUI

@MainActor
class ExercisesManager: ObservableObject {
    private let service: ExerciseService

    init(service: ExerciseService) {
        self.service = service
    }

    // MARK: - Services

    func fetchExercises() async throws -> Exercises {
        try await service.fetchExercises()
    }
}

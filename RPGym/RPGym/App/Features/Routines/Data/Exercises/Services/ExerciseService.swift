//
//  ExerciseService.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-18.
//

import Foundation

protocol ExerciseService: Sendable {
    func fetchExercises() async throws -> [Exercise]
}

struct ExerciseServiceImpl: ExerciseService {

    func fetchExercises() async throws -> [Exercise] {
        return []
    }
}

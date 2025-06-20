//
//  ExercisesManagerTest.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import Testing
@testable import RPGym

struct ExercisesManagerTest {

    @Test func fetchExercisesSuccess() async throws {
        let manager = await ExercisesManager(service: FileReaderServiceImpl())
        let result = try await manager.fetchExercises()
        #expect(result[0].id == "crunch")
    }
}

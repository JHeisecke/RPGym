//
//  MusclesManagerTest.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import Testing
@testable import RPGym

struct MusclesManagerTest {

    @Test func fetchMuscleGroupsSuccess() async throws {
        let manager = await MusclesManager(service: FileReaderServiceImpl())
        let result = try await manager.fetchMuscleGroups()
        #expect(result[0].id == "chest")
    }

    @Test func fetchMusclesSuccess() async throws {
        let manager = await MusclesManager(service: FileReaderServiceImpl())
        let result = try await manager.fetchMuscles()
        #expect(result[0].id == "pectoralis-major")
    }
}

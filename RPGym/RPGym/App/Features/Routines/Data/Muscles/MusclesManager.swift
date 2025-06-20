//
//  MusclesManager.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import SwiftUI

@MainActor
class MusclesManager: ObservableObject {
    private let service: FileReaderService
    private(set) var muscleGroups: MuscleGroups = []
    private(set) var muscles: Muscles = []

    init(service: FileReaderService) {
        self.service = service
    }

    // MARK: - Services

    func fetchMuscleGroups() async throws -> MuscleGroups {
        guard muscleGroups.isEmpty else { return muscleGroups }
        let result: MuscleGroups = try await service.read(from: File.muscle_groups)
        muscleGroups = result
        return result
    }

    func fetchMuscles() async throws -> Muscles {
        guard muscles.isEmpty else { return muscles }
        let result: Muscles = try await service.read(from: File.muscles)
        muscles = result
        return result
    }
}

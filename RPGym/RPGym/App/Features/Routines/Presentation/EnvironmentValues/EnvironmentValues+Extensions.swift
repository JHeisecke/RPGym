//
//  EnvironmentValues+Extensions.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import SwiftUI

struct ExercisesManagerKey: EnvironmentKey {
    static let defaultValue: ExercisesManager = ExercisesManager(service: ExerciseServiceImpl())
}

// Extend EnvironmentValues to include the key
extension EnvironmentValues {
    var exercisesManager: ExercisesManager {
        get { self[ExercisesManagerKey.self] }
        set { self[ExercisesManagerKey.self] = newValue }
    }
}

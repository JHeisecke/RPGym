//
//  RoutineService.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-18.
//

import Foundation

protocol RoutineService: Sendable {
    func fetchRoutines() async throws -> [Routine]
}

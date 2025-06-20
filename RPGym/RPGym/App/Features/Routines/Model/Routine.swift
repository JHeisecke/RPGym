//
//  Routine.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-18.
//

import Foundation

struct Routine: Identifiable, Codable {
    let id: String
    let name: String
    let muscles: [String]
    let exercises: [String]
}

extension Routine {
    static let mocks: [Routine] = [
        .init(id: "1", name: "Chest Madness", muscles: ["Chest"], exercises: ["Bench Press", "Overhead Press"]),
        .init(id: "2", name: "Back Day", muscles: ["Back"], exercises: ["Deadlift", "Pull-Ups"]),
        .init(id: "3", name: "Legs", muscles: ["Legs"], exercises: ["Squats"]),
        .init(id: "4", name: "Shoulders", muscles: ["Shoulders"], exercises: ["Overhead Press"]),
        .init(id: "5", name: "Biceps", muscles: ["Biceps"], exercises: ["Barbell Curl"])

    ]
}

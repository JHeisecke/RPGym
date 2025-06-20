//
//  NavigationPathOption.swift
//  AIChatPartner
//
//  Created by Javier Heisecke on 2025-01-29.
//

import SwiftUI

class Navigation: ObservableObject {
    @Published var path: [NavigationPathOption] = []
}

enum NavigationPathOption: Hashable {
    case profile
    case settings
    case fitnessPlan
    case routines
    case exercise(exercise: Exercise)
}

extension View {
    func navigationDestionationForCoreModule(path: Binding<[NavigationPathOption]>) -> some View {
        self
            .navigationDestination(for: NavigationPathOption.self) { option in
                switch option {
                case .fitnessPlan:
                    FitnessPlanView()
                case .routines:
                    ExercisesView()
                case .profile:
                    ProfileView()
                case .settings:
                    SettingsView()
                case .exercise(let exercise):
                    ExerciseDetailView(exercise: exercise)
                }
            }
    }
}

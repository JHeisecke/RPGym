//
//  RPGymApp.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-08.
//

import SwiftUI

@main
struct RPGymApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(delegate.dependencies.exercisesManager)
        }
    }
}

// MARK: - AppDelegate

class AppDelegate: NSObject, UIApplicationDelegate {
    var dependencies: Dependencies!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let config: BuildConfiguration

        // #if DEV
        config = .dev

        config.configure()
        dependencies = Dependencies(config: config)
        return true
    }
}

enum BuildConfiguration {
    case mock(signedIn: Bool), dev, prod

    func configure() {
        switch self {
        case .mock:
            return
        case .dev:
            let plist = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")!
        case .prod:
            let plist = Bundle.main.path(forResource: "GoogleService-Info-Prod", ofType: "plist")!
        }
    }
}

// MARK: - Dependencies

@MainActor
struct Dependencies {
    let exercisesManager: ExercisesManager!

    init(config: BuildConfiguration) {

        switch config {
        case .mock:
            self.exercisesManager = ExercisesManager(service: ExerciseServiceImpl())
        case .dev:
            self.exercisesManager = ExercisesManager(service: ExerciseServiceImpl())
        case .prod:
            self.exercisesManager = ExercisesManager(service: ExerciseServiceImpl())
        }
    }
}

// MARK: - View Extension

extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(ExercisesManager(service: ExerciseServiceImpl()))
    }
}

//
//  RPGymApp.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-08.
//

import SwiftUI
import FirebaseCore

@main
struct RPGymApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.light)
                .environmentObject(delegate.dependencies.exercisesManager)
                .environmentObject(delegate.dependencies.musclesManager)
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
        default:
            let plist = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
            let options = FirebaseOptions(contentsOfFile: plist)!
            FirebaseApp.configure(options: options)
        }
    }
}

// MARK: - Dependencies

@MainActor
struct Dependencies {
    let exercisesManager: ExercisesManager!
    let musclesManager: MusclesManager!

    init(config: BuildConfiguration) {

        switch config {
        default:
            self.exercisesManager = ExercisesManager(service: FileReaderServiceImpl())
            self.musclesManager = MusclesManager(service: FileReaderServiceImpl())
        }
    }
}

// MARK: - View Extension

extension View {
    func previewEnvironment() -> some View {
        self
            .environmentObject(ExercisesManager(service: FileReaderServiceImpl()))
            .environmentObject(MusclesManager(service: FileReaderServiceImpl()))
    }
}

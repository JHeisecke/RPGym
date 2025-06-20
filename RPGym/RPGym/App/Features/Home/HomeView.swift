//
//  ContentView 2.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-08.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var exercisesManager: ExercisesManager
    @EnvironmentObject private var musclesManager: MusclesManager
    @StateObject private var navigation = Navigation()

    private let options = MenuOption.allCases

    @State private var orientation = UIDeviceOrientation.unknown

    var isPortrait: Bool {
        switch orientation {
        case .portrait, .unknown, .portraitUpsideDown:
            true
        default:
            false
        }
    }

    var body: some View {
        NavigationStack(path: $navigation.path) {
            GeometryReader { geometry in
                ZStack {
                    Image("gym_wallpaper")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    gridMenu(containerSize: isPortrait ? geometry.size.width : geometry.size.height)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                        .padding(.bottom, geometry.size.height * 0.15)
                }
            }
            .ignoresSafeArea()
            .onRotate { newOrientation in
                guard newOrientation != .faceDown, newOrientation != .faceUp else { return }
                orientation = newOrientation
            }
            .navigationDestionationForCoreModule(path: $navigation.path)
            .task {
                await getNecessaryData()
            }
        }
        .environmentObject(navigation)
    }

    // MARK: - Portrait

    private func gridMenu(containerSize: CGFloat) -> some View {
        HStack(spacing: Constans.spacing) {
            VStack(spacing: Constans.spacing) {
                homeButton(.profile, containerSize: containerSize)
                homeButton(.routine, containerSize: containerSize)
            }
            VStack(spacing: Constans.spacing) {
                homeButton(.fitnessPlan, containerSize: containerSize)
                homeButton(.settings, containerSize: containerSize)
            }
        }
    }

    // MARK: - Buttons

    @ViewBuilder
    private func homeButton(_ option: MenuOption, containerSize: CGFloat) -> some View {
        option.image
            .resizable()
            .frame(width: containerSize * 0.45, height: containerSize * 0.45)
            .anyButton(option.style, action: {
                switch option {
                case .profile:
                    onProfileButtonPressed()
                case .fitnessPlan:
                    onFitnessPlanButtonPressed()
                case .routine:
                    onRoutinesButtonPressed()
                case .settings:
                    onSettingsButtonPressed()
                }
            })
            .shadow(color: .white, radius: 2)
    }

    // MARK: - Actions

    private func onProfileButtonPressed() {
        navigation.path.append(.profile)
    }

    private func onFitnessPlanButtonPressed() {
        navigation.path.append(.fitnessPlan)
    }

    private func onSettingsButtonPressed() {
        navigation.path.append(.settings)
    }

    private func onRoutinesButtonPressed() {
        navigation.path.append(.routines)
    }

    private func getNecessaryData() async {
        async let fetchExercises: [Exercise] = exercisesManager.fetchExercises()
        async let fetchMuscles: Muscles = musclesManager.fetchMuscles()
        async let fetchMuscleGroups: MuscleGroups = musclesManager.fetchMuscleGroups()

        let (_, _, _) = await (try? fetchExercises, try? fetchMuscles, try? fetchMuscleGroups)
    }

    // MARK: - Types

    enum MenuOption: String, CaseIterable, Identifiable, Hashable {
        case routine, fitnessPlan, profile, settings
        var id: String { self.rawValue }

        var image: Image {
            switch self {
            case .routine: Image("dumbbell")
            case .profile: Image("profile")
            case .settings: Image("settings")
            case .fitnessPlan: Image("calendar")
            }
        }

        var style: ButtonStyleOption {
            switch self {
            case .routine: .rotate
            case .profile: .highlight
            case .settings: .press
            case .fitnessPlan: .press
            }
        }
    }

    struct Constans {
        static let spacing: CGFloat = 20
    }
}

// MARK: - Preview

#Preview {
    HomeView()
        .previewEnvironment()
}

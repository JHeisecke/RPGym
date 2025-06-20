//
//  ContentView 2.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-08.
//

import SwiftUI

struct HomeView: View {

    private let options = MenuOption.allCases

    @State private var orientation = UIDeviceOrientation.unknown
    @State private var path: [NavigationPathOption] = []

    var isPortrait: Bool {
        switch orientation {
        case .portrait, .unknown, .portraitUpsideDown:
            true
        default:
            false
        }
    }

    @Namespace private var namespace
//    private var columns: [GridItem] {
//        return [
//            .init(.adaptive(minimum: Constans.buttonSize, maximum: Constans.buttonSize), spacing: Constans.spacing)
//        ]
//    }
    
    var body: some View {
        NavigationStack(path: $path) {
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
            .navigationDestionationForCoreModule(path: $path)
        }

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

    private var landscapeMenu: some View {
        HStack(spacing: Constans.spacing) {
            ForEach(options) { option in
//                homeButton(option)
            }
        }
    }

    private var portraitMenu: some View {
        VStack(spacing: Constans.spacing) {
            ForEach(options) { option in
//                homeButton(option)
            }
        }
    }

    // MARK: - LazyVGrid

//    private func grid(containerSize: CGFloat) -> some View {
//        LazyVGrid(columns: columns, spacing: Constans.spacing) {
//            ForEach(options) { option in
//                homeButton(option, containerSize: containerSize)
//            }
//        }
//    }

    // MARK: - Buttons

    @ViewBuilder
    private func homeButton(_ option: MenuOption, containerSize: CGFloat) -> some View {
        if let image = option.image {
            image
                .resizable()
                .frame(width: containerSize * 0.45, height: containerSize * 0.45)
                .matchedGeometryEffect(id: option.imageName, in: namespace)
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
        } else {
            Image(systemName: option.imageName)
                .font(.system(size: containerSize * 0.2))
                .frame(width: containerSize * 0.45, height: containerSize * 0.45)
                .matchedGeometryEffect(id: option.imageName, in: namespace)
                .neumorphicStyle()
                .anyButton(.press, action: {
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
        }
    }

    // MARK: - Actions

    private func onProfileButtonPressed() {
        path.append(.profile)
    }

    private func onFitnessPlanButtonPressed() {
        path.append(.fitnessPlan)
    }

    private func onSettingsButtonPressed() {
        path.append(.settings)
    }

    private func onRoutinesButtonPressed() {
        path.append(.routines)
    }


    // MARK: - Types

    enum MenuOption: String, CaseIterable, Identifiable, Hashable {
        case routine, fitnessPlan, profile, settings
        var id: String { self.rawValue }

        var imageName: String {
            switch self {
            case .routine: "dumbbell"
            case .fitnessPlan: "calendar"
            case .profile: "profile"
            case .settings: "settings"
            }
        }

        var image: Image? {
            switch self {
            case .routine: Image("dumbbell")
            case .profile: Image("profile")
            case .settings: Image("settings")
            default: nil
            }
        }

        var style: ButtonStyleOption {
            switch self {
            case .routine: .rotate
            case .profile: .highlight
            case .settings: .press
            default: .plain
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
}

extension View {
    func neumorphicStyle() -> some View {
        self
            .background(Color.offWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
    }

}

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
}

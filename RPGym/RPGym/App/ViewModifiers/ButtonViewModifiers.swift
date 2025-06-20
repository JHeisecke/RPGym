//
//  HighlightButtonStyle.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-03.
//


import SwiftUI

struct RotateButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .rotationEffect(Angle(degrees: configuration.isPressed ? 15 : 0))
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.accentColor.opacity(0.5) : Color.accentColor.opacity(0)
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case press, highlight, plain, rotate
}

extension View {

    @ViewBuilder
    func anyButton(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .press:
            self.pressableButton(action: action)
        case .highlight:
            self.highlightButton(action: action)
        case .plain:
            self.plainButton(action: action)
        case .rotate:
            self.rotateButton(action: action)
        }
    }

    private func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
    }

    private func rotateButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(RotateButtonStyle())
    }

    private func highlightButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(HighlightButtonStyle())
    }

    private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        Text("Hello, World!")
            .padding()
            .frame(maxWidth: .infinity)
            .tappableBackground()
            .anyButton(.plain, action: {})

        Text("Hello, World!")
            .padding()
            .frame(maxWidth: .infinity)
            .tappableBackground()
            .anyButton(.highlight, action: {})

        Text("Hello, World!")
            .padding()
            .frame(maxWidth: .infinity)
            .tappableBackground()
            .anyButton(.press, action: {})

        Text("Hello, World!")
            .padding()
            .frame(maxWidth: .infinity)
            .tappableBackground()
            .anyButton(.rotate, action: {})

        Button {

        } label: {
            Text("Hello, World!")
                .callToActionButton()
        }
        .padding(.horizontal)
        .buttonStyle(.plain)
    }
}

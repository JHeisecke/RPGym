//
//  DeviceOrientationKey.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-08.
//

import SwiftUI

private struct DeviceOrientationKey: EnvironmentKey {
    static let defaultValue: UIDeviceOrientation = .unknown
}

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

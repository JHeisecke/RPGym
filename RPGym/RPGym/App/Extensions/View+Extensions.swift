//
//  View+Extensions.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-14.
//

import SwiftUI

extension View {
    func tappableBackground() -> some View {
        self.background(.black.opacity(0.0001))
    }

    func callToActionButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.accent)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func removeListRowFormatting() -> some View {
        self
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

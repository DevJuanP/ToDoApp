//
//  BrandMark.swift
//  ToDoApp
//

import SwiftUI

/// Logotipo de la app: cuadrado verde con check.
struct BrandMark: View {
    var size: CGFloat = 40

    private let check = CheckGlyph()

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Theme.pine, Theme.pineDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                check
                    .stroke(
                        Theme.onPine,
                        style: StrokeStyle(lineWidth: size * 0.105, lineCap: .round, lineJoin: .round)
                    )
                    .padding(size * 0.27)
            )
            .accessibilityHidden(true)
    }
}

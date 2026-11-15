//
//  BrandHeader.swift
//  ToDoApp
//

import SwiftUI

/// Fila de marca que corona las pantallas.
struct BrandHeader: View {
    private let name: String
    private let markSize: CGFloat

    init(name: String = "ToDoApp", markSize: CGFloat = 40) {
        self.name = name
        self.markSize = markSize
    }

    var body: some View {
        HStack(spacing: 12) {
            BrandMark(size: markSize)

            Text(name)
                .font(.system(size: 15, weight: .semibold))
                .kerning(0.5)
                .foregroundStyle(Theme.inkSoft)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(name)
    }
}

//
//  PlaceholderText.swift
//  ToDoApp
//

import SwiftUI

/// Texto guía que se dibuja bajo el cursor del campo.
///
/// No intercepta toques ni se anuncia: el campo ya lleva su etiqueta accesible.
struct PlaceholderText: View {
    private let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .foregroundStyle(Theme.inkSoft)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }
}

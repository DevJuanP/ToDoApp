//
//  FormErrorLabel.swift
//  ToDoApp
//

import SwiftUI

/// Mensaje de error de formulario: qué pasó y cómo seguir.
struct FormErrorLabel: View {
    private let message: String

    init(_ message: String) {
        self.message = message
    }

    var body: some View {
        Label(message, systemImage: "exclamationmark.circle.fill")
            .font(.footnote)
            .foregroundStyle(Theme.danger)
            .fixedSize(horizontal: false, vertical: true)
    }
}

//
//  LoginHeader.swift
//  ToDoApp
//

import SwiftUI

/// Titular y subtítulo de la pantalla de acceso.
struct LoginHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hola de nuevo")
                .font(.system(.largeTitle, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("Entra para retomar los pendientes de hoy.")
                .font(.callout)
                .foregroundStyle(Theme.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

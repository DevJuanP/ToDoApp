//
//  AppBackdrop.swift
//  ToDoApp
//

import SwiftUI

/// Fondo de la app: papel cálido con dos resplandores.
///
/// Compartido por todas las pantallas para mantener una sola atmósfera.
struct AppBackdrop: View {
    var body: some View {
        ZStack {
            Theme.paper

            RadialGradient(
                colors: [Theme.pine.opacity(0.11), Theme.pine.opacity(0)],
                center: UnitPoint(x: 0.92, y: -0.06),
                startRadius: 12,
                endRadius: 470
            )

            RadialGradient(
                colors: [Theme.ink.opacity(0.05), Theme.ink.opacity(0)],
                center: UnitPoint(x: 0.02, y: 1.04),
                startRadius: 8,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

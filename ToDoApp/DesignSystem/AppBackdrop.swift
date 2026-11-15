//
//  AppBackdrop.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Fondo de la app: papel cálido con dos resplandores.
///
/// Compartido por todas las pantallas para mantener una sola atmósfera.
///
/// Los dos resplandores son `RadialGradient` que se desvanecen hasta opacidad
/// cero. Su función es dar profundidad sin dibujar una forma: no se perciben
/// como manchas, solo como que la superficie tiene luz. Uno verde arriba a la
/// derecha (cerca de la marca) y uno oscuro abajo a la izquierda, para que la
/// pantalla no se sienta plana.
///
/// `ignoresSafeArea()` es necesario porque el fondo debe llegar bajo la isla
/// dinámica y el indicador de inicio; de lo contrario aparecerían franjas.
struct AppBackdrop: View {
    var body: some View {
        ZStack {
            // Capa base opaca: el resto de capas se dibujan encima.
            Theme.paper

            // `startRadius` pequeño y `endRadius` grande producen un degradado
            // suave, sin borde visible.
            RadialGradient(
                colors: [Theme.pine.opacity(0.11), Theme.pine.opacity(0)],
                center: UnitPoint(x: 0.92, y: -0.06), // fuera de pantalla arriba-derecha
                startRadius: 12,
                endRadius: 470
            )

            RadialGradient(
                colors: [Theme.ink.opacity(0.05), Theme.ink.opacity(0)],
                center: UnitPoint(x: 0.02, y: 1.04), // fuera de pantalla abajo-izquierda
                startRadius: 8,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

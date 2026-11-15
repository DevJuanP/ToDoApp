//
//  SecondaryButton.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Acción secundaria: contorno fino sobre el fondo.
///
/// La jerarquía visual se construye por contraste de peso, no por color:
/// el botón principal es sólido y este es un contorno. Así la persona
/// entiende de inmediato cuál es la acción esperada sin que haya que
/// leer los textos.
///
/// Comparte `PressButtonStyle` con el principal, de modo que la respuesta
/// al toque es idéntica aunque la apariencia no lo sea.
struct SecondaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Theme.ink)
                // Un punto menos de alto que el principal (54 vs 56):
                // mismo lenguaje, un peldaño por debajo.
                .frame(maxWidth: .infinity, minHeight: 54)
                .background(
                    // `strokeBorder` (y no `stroke`) dibuja el borde hacia
                    // dentro, así que no sobresale del rectángulo previsto.
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(Theme.hairline, lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(PressButtonStyle())
    }
}

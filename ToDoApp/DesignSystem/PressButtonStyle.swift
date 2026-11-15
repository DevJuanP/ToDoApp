//
//  PressButtonStyle.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Respuesta táctil común a los botones de la app.
///
/// Un `ButtonStyle` es la forma correcta de dar respuesta al toque en SwiftUI:
/// se aplica con `.buttonStyle(PressButtonStyle())` y afecta a todos los
/// botones de ese subárbol. Así la sensación es idéntica en el botón
/// principal y en el secundario, sin repetir el efecto en cada uno.
///
/// Los valores están elegidos para que se sienta físico y no exagerado:
///
///   - **escala 0.975**: el botón se hunde un 2.5 %. Más se notaría como un
///     salto; menos, como que no responde.
///   - **resorte con `dampingFraction` 0.65**: vuelve con un rebote mínimo,
///     que es lo que diferencia un toque "vivo" de uno robótico.
///
/// `configuration.label` es el contenido del botón ya construido; el estilo
/// solo lo envuelve, no lo reemplaza.
struct PressButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

//
//  PlaceholderText.swift
//  ToDoApp
//
//  CAPA: Design System (formulario)
//

import SwiftUI

/// Texto guía que se dibuja bajo el cursor del campo.
///
/// No intercepta toques ni se anuncia: el campo ya lleva su etiqueta accesible.
///
/// **Por qué un componente y no `.foregroundStyle` repetido.** Los dos campos
/// necesitan el mismo comportamiento, y ese comportamiento tiene dos reglas
/// que es fácil olvidar:
///
///   - `.allowsHitTesting(false)`: si el texto capturara el toque, tocar sobre
///     el marcador no enfocaría el campo. Es el fallo clásico de un ZStack.
///   - `.accessibilityHidden(true)`: VoiceOver leería el marcador y luego el
///     campo, duplicando la información; además un marcador no es contenido,
///     es una pista visual.
///
/// Encapsularlas aquí garantiza que ningún placeholder futuro las omita.
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

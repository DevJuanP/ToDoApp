//
//  FormErrorLabel.swift
//  ToDoApp
//
//  CAPA: Design System (formulario)
//

import SwiftUI

/// Mensaje de error de formulario: qué pasó y cómo seguir.
///
/// Recibe texto ya redactado; no compone mensajes. La redacción vive en las
/// reglas de validación, que son las que conocen el contexto del fallo.
///
/// Detalles pensados para leerse bien:
///   - El icono `exclamationmark.circle.fill` da forma, no solo color: quien
///     no distingue el rojo sigue viendo que algo va mal.
///   - `fixedSize(vertical: true)` permite que el mensaje ocupe varias líneas
///     en pantallas estrechas o con Dynamic Type grande, en vez de truncarse.
///     Un error truncado es peor que ninguno.
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

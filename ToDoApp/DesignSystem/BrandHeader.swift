//
//  BrandHeader.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Fila de marca que corona las pantallas.
///
/// Agrupa marca y nombre con valores por defecto, de modo que
/// `BrandHeader()` ya es la versión correcta.
///
/// Los parámetros existen porque otra pantalla podría necesitar la marca
/// más grande, pero **no se inventan opciones que nadie usa** (YAGNI):
/// hoy solo hay dos casos, tamaño 40 con nombre y tamaño 56 sin él.
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
                // `kerning` abre ligeramente las letras: los nombres en
                // mayúsculas y minúsculas a tamaño pequeño ganan presencia.
                .kerning(0.5)
                .foregroundStyle(Theme.inkSoft)
        }
        // `.combine` fusiona logo y texto en un solo elemento accesible.
        // Sin esto, VoiceOver anunciaría dos elementos, uno de ellos mudo.
        .accessibilityElement(children: .combine)
        .accessibilityLabel(name)
    }
}

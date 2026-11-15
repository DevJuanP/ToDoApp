//
//  CheckGlyph.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Trazo del check de la marca.
///
/// Es un `Shape` y no una `Image(systemName:)` porque un símbolo del sistema
/// no se puede ajustar con la proporción exacta de la marca: aquí cada punto
/// está expresado como fracción del `rect`, así que el trazo es idéntico a
/// cualquier tamaño.
///
/// El patrón de tres puntos es el mínimo para un check:
///   - bajo a la izquierda (inicio del trazo corto)
///   - abajo, el vértice
///   - alto a la derecha (final del trazo largo)
///
/// Los valores no son arbitrarios: el vértice está a 0.84 de altura y el
/// extremo derecho a 0.16, lo que da la inclinación característica de un check.
/// El trazo corto empieza desplazado (0.06) para que el remate redondeado
/// no quede pegado al borde izquierdo.
struct CheckGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.minY + rect.height * 0.54))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.38, y: rect.minY + rect.height * 0.84))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.96, y: rect.minY + rect.height * 0.16))
        return path
    }
}

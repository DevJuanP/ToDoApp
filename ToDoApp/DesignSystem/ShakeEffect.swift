//
//  ShakeEffect.swift
//  ToDoApp
//

import SwiftUI

/// Desplazamiento horizontal de rechazo, reutilizable por cualquier formulario.
struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: 9 * sin(animatableData * .pi * 3), y: 0)
        )
    }
}

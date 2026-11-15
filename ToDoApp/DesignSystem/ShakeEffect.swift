//
//  ShakeEffect.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Desplazamiento horizontal de rechazo, reutilizable por cualquier formulario.
///
/// **Cómo funciona un `GeometryEffect`.** SwiftUI lo llama pidiendo una
/// `ProjectionTransform` (una matriz) que aplica a la vista. Al declarar
/// `animatableData`, SwiftUI interpola ese valor entre 0 y N y vuelve a pedir
/// la matriz en cada fotograma: de ahí sale el movimiento continuo.
///
/// **La fórmula.** `sin(x) * 9` usa una onda sinusoidal como desplazamiento:
///
///   - empieza y termina en 0 (no hay salto al acabar),
///   - cambia de signo varias veces (va y vuelve),
///   - el multiplicador `3π` da tres semiciclos, es decir tres sacudidas.
///
/// Una alternativa habitual es una interpolación por tramos, pero la onda
/// produce un movimiento que se frena solo y se siente más natural.
///
/// Se aplica a un `VStack` contenedor y no a cada campo: si cada uno se
/// moviera por su cuenta, los bordes se desalinearían entre sí.
struct ShakeEffect: GeometryEffect {

    /// Valor animable: 0 es quieto, y cada incremento del contador añade
    /// una sacudida completa.
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: 9 * sin(animatableData * .pi * 3), y: 0)
        )
    }
}

//
//  Theme.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Tokens de diseño: única fuente de verdad para el color.
///
/// Ninguna vista declara colores literales; todas leen de aquí.
///
/// **Por qué esto es más que orden estético.** Un color repetido en cinco
/// archivos es una decisión que no se puede cambiar sin buscarla. Con tokens,
/// "ajustar el papel a un tono más frío" es editar una línea. Es la misma
/// idea de DRY que `PasswordPolicy`, aplicada al diseño.
///
/// **Por qué hay un valor para claro y otro para oscuro.** El modo oscuro no
/// es el claro invertido: los colores de fondo muy claros se vuelven casi
/// negros (no blancos), y los acentos necesitan más luminosidad para no
/// desaparecer sobre fondo oscuro. Por eso `pine` es verde profundo en claro
/// y verde menta en oscuro: misma identidad, distinta luminancia.
enum Theme {
    // Superficies
    static let paper = Color.dynamic(light: 0xFAF7F2, dark: 0x121311)
    static let field = Color.dynamic(light: 0xFFFFFF, dark: 0x1C1E1B)

    // Texto
    static let ink = Color.dynamic(light: 0x1A1A1D, dark: 0xF3F0EA)
    static let inkRaised = Color.dynamic(light: 0x2B2B30, dark: 0xFFFFFF)

    /// Texto secundario. No es gris puro: lleva una pizca del tono del papel
    /// para no verse "suelto" sobre el fondo cálido.
    static let inkSoft = Color.dynamic(light: 0x5F5F67, dark: 0xA9A69E)

    // Líneas y bordes
    static let hairline = Color.dynamic(light: 0xE0DAD0, dark: 0x34362F)

    // Acento: el verde de la marca, tomado del mundo del "check"
    static let pine = Color.dynamic(light: 0x2E5B4A, dark: 0x74C0A2)
    static let pineDeep = Color.dynamic(light: 0x1F4436, dark: 0x4E9A80)

    // Semánticos
    /// Rojo de error. Apagado a propósito: no es una alarma, es un aviso.
    static let danger = Color.dynamic(light: 0x9E3223, dark: 0xEC9382)

    /// Texto sobre el botón principal (fondo `ink`). Se llama `onInk` y no
    /// `white` porque en modo oscuro el botón es claro y el texto debe ser
    /// oscuro: el nombre describe la relación, no el color.
    static let onInk = Color.dynamic(light: 0xFAF7F2, dark: 0x11120F)

    /// Texto sobre la marca verde (el check).
    static let onPine = Color.dynamic(light: 0xFCFAF5, dark: 0x0E1F18)
}

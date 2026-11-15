//
//  Theme.swift
//  ToDoApp
//

import SwiftUI

/// Tokens de diseño: única fuente de verdad para el color.
///
/// Ninguna vista declara colores literales; todas leen de aquí.
enum Theme {
    static let paper = Color.dynamic(light: 0xFAF7F2, dark: 0x121311)
    static let field = Color.dynamic(light: 0xFFFFFF, dark: 0x1C1E1B)
    static let ink = Color.dynamic(light: 0x1A1A1D, dark: 0xF3F0EA)
    static let inkRaised = Color.dynamic(light: 0x2B2B30, dark: 0xFFFFFF)
    static let inkSoft = Color.dynamic(light: 0x5F5F67, dark: 0xA9A69E)
    static let hairline = Color.dynamic(light: 0xE0DAD0, dark: 0x34362F)
    static let pine = Color.dynamic(light: 0x2E5B4A, dark: 0x74C0A2)
    static let pineDeep = Color.dynamic(light: 0x1F4436, dark: 0x4E9A80)
    static let danger = Color.dynamic(light: 0x9E3223, dark: 0xEC9382)
    static let onInk = Color.dynamic(light: 0xFAF7F2, dark: 0x11120F)
    static let onPine = Color.dynamic(light: 0xFCFAF5, dark: 0x0E1F18)
}

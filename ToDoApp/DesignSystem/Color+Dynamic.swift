//
//  Color+Dynamic.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI
import UIKit

extension Color {
    /// Color que se adapta entre apariencia clara y oscura a partir de dos literales hexadecimales.
    ///
    /// `UIColor(dynamicProvider:)` es la API de UIKit que resuelve un color
    /// según los rasgos del entorno (apariencia, contraste, gama). SwiftUI la
    /// envuelve con `Color(uiColor:)`, de modo que el `Color` resultante sigue
    /// siendo dinámico: cambia solo si la persona cambia de apariencia con la
    /// app abierta, sin reiniciar.
    ///
    /// Sin esto habría que duplicar cada color en el catálogo de assets o
    /// resolver los colores a mano en cada vista. Aquí se declara una vez,
    /// junto al resto de tokens.
    ///
    /// El closure `dynamicProvider` se ejecuta cada vez que el sistema
    /// pregunta por el color, así que no debe hacer trabajo costoso.
    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor(dynamicProvider: { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        }))
    }
}

private extension UIColor {
    /// Construye un color opaco desde un literal hexadecimal `0xRRGGBB`.
    ///
    /// Se escriben los colores así porque `0x2E5B4A` se lee (y se copia de
    /// una herramienta de diseño) mucho mejor que
    /// `Color(red: 0.180, green: 0.357, blue: 0.290)`.
    ///
    /// Las máscaras `>>` y `&` separan los tres canales:
    ///   0xRRGGBB >> 16       → RR
    ///   (…) >> 8 & 0xFF      → GG
    ///   (…) & 0xFF           → BB
    /// El `/ 255` convierte el byte (0–255) al rango 0–1 que espera UIColor.
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}

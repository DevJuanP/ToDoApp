//
//  Color+Dynamic.swift
//  ToDoApp
//

import SwiftUI
import UIKit

extension Color {
    /// Color que se adapta entre apariencia clara y oscura a partir de dos literales hexadecimales.
    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor(dynamicProvider: { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        }))
    }
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}

//
//  CheckGlyph.swift
//  ToDoApp
//

import SwiftUI

/// Trazo del check de la marca.
struct CheckGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.minY + rect.height * 0.54))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.38, y: rect.minY + rect.height * 0.84))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.96, y: rect.minY + rect.height * 0.16))
        return path
    }
}

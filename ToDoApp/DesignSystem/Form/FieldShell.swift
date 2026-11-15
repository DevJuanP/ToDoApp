//
//  FieldShell.swift
//  ToDoApp
//

import SwiftUI

/// Marco visual de un campo: etiqueta arriba y recuadro con borde de estado.
///
/// No sabe qué se escribe dentro; por eso sirve para texto y para contraseña.
struct FieldShell<Content: View>: View {
    private let label: String
    private let isFocused: Bool
    private let isInvalid: Bool
    private let content: Content

    init(
        label: String,
        isFocused: Bool,
        isInvalid: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.isFocused = isFocused
        self.isInvalid = isInvalid
        self.content = content()
    }

    private var borderColor: Color {
        if isInvalid { return Theme.danger }
        return isFocused ? Theme.pine : Theme.hairline
    }

    private var borderWidth: CGFloat {
        isInvalid || isFocused ? 1.6 : 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(isInvalid ? Theme.danger : Theme.inkSoft)

            content
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Theme.field)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                .animation(.easeOut(duration: 0.18), value: isFocused)
                .animation(.easeOut(duration: 0.18), value: isInvalid)
        }
    }
}

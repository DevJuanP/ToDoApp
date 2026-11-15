//
//  FieldShell.swift
//  ToDoApp
//
//  CAPA: Design System (formulario)
//

import SwiftUI

/// Marco visual de un campo: etiqueta arriba y recuadro con borde de estado.
///
/// No sabe qué se escribe dentro; por eso sirve para texto y para contraseña.
///
/// **Este es el mejor ejemplo de `@ViewBuilder` genérico del proyecto.**
/// El tipo es `FieldShell<Content: View>`: recibe contenido arbitrario y
/// solo se encarga de la cáscara. Gracias a eso, `EmailField` y
/// `PasswordField` no repiten ni la etiqueta, ni el borde, ni las esquinas,
/// ni la animación del borde. Y si mañana se agrega un campo de teléfono,
/// la cáscara ya está resuelta (DRY a nivel de componente).
///
/// El estado se traduce a color en un solo sitio (`borderColor`), así que
/// "inválido gana a enfocado" es una regla escrita una vez.
struct FieldShell<Content: View>: View {
    private let label: String
    private let isFocused: Bool
    private let isInvalid: Bool
    private let content: Content

    /// El inicializador recibe `content` como closure con `@ViewBuilder`,
    /// no como valor ya construido. Eso permite escribir la sintaxis de
    /// trailing closure que se ve en los usos:
    ///
    ///     FieldShell(label: "Correo", ...) { TextField(...) }
    init(
        label: String,
        isFocused: Bool,
        isInvalid: Bool,
        @ViewBuilder content: () -> Content
    ) {
        self.label = label
        self.isFocused = isFocused
        self.isInvalid = isInvalid
        self.content = content() // se evalúa una vez, aquí
    }

    private var borderColor: Color {
        // El orden importa: un campo inválido se queda rojo aunque esté
        // enfocado. Se prioriza "hay un problema" sobre "está activo".
        if isInvalid { return Theme.danger }
        return isFocused ? Theme.pine : Theme.hairline
    }

    private var borderWidth: CGFloat {
        // Engrosar el borde en vez de añadir un anillo: más discreto y no
        // cambia el tamaño del contenido.
        isInvalid || isFocused ? 1.6 : 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(label)
                .font(.footnote.weight(.semibold))
                // La etiqueta acompaña el estado de error: refuerza el mensaje
                // sin depender solo del color (importante para daltonismo).
                .foregroundStyle(isInvalid ? Theme.danger : Theme.inkSoft)

            content
                .padding(.horizontal, 16)
                // Alto fijo de 54: todos los campos miden lo mismo aunque
                // el contenido interno cambie.
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Theme.field)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        // `strokeBorder` dibuja el trazo hacia dentro, así el
                        // borde de 1.6 no altera las medidas del campo.
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                // Dos animaciones separadas a propósito: enfocar y fallar son
                // eventos independientes y no deben mezclarse.
                .animation(.easeOut(duration: 0.18), value: isFocused)
                .animation(.easeOut(duration: 0.18), value: isInvalid)
        }
    }
}

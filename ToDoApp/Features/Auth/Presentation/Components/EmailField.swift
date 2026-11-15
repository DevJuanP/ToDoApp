//
//  EmailField.swift
//  ToDoApp
//
//  CAPA: Presentación (componente)
//

import SwiftUI

/// Campo de correo con su teclado, autocorrección y navegación.
///
/// Este componente es **autónomo**: no conoce el view model ni el formulario.
/// Recibe texto, dice si está enfocado o inválido, y avisa cuando se pulsa
/// "siguiente". Por eso se puede usar en cualquier otra pantalla.
///
/// Recibe `@FocusState.Binding` en lugar de gestionar su propio foco porque
/// el foco es un recurso compartido entre los dos campos: si cada uno tuviera
/// el suyo, no se podría saltar de uno al otro.
struct EmailField: View {
    @Binding var email: String
    let isFocused: Bool
    let isInvalid: Bool
    let onSubmit: () -> Void

    @FocusState.Binding var focusedField: LoginField?

    var body: some View {
        FieldShell(label: "Correo", isFocused: isFocused, isInvalid: isInvalid) {
            HStack(spacing: 11) {
                Image(systemName: "envelope")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.inkSoft)
                    .frame(width: 20) // ancho fijo: alinea con el icono de candado

                // ZStack para poner el marcador DEBAJO del texto y no como
                // `prompt` del TextField. Así el marcador puede tener su propio
                // estilo y no desaparece con animaciones raras del sistema.
                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        PlaceholderText("tu@correo.com")
                    }

                    // El label vacío es intencional: la etiqueta visible ya
                    // está en `FieldShell` y la accesible en `.accessibilityLabel`.
                    // Poner un prompt aquí duplicaría el texto en VoiceOver.
                    TextField("", text: $email)
                        .focused($focusedField, equals: .email)
                        // Ajustes de teclado que ahorran errores reales:
                        .keyboardType(.emailAddress)        // arroba y punto a mano
                        .textContentType(.username)         // autocompletado de contraseñas
                        .textInputAutocapitalization(.never) // un correo nunca lleva mayúscula inicial
                        .autocorrectionDisabled()            // el corrector estropea correos
                        .submitLabel(.next)                  // la tecla dice "siguiente"
                        .onSubmit(onSubmit)                  // y salta a la contraseña
                        .foregroundStyle(Theme.ink)
                        .accessibilityLabel("Correo electrónico")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17)) // 17 pt es el cuerpo de iOS
            }
        }
    }
}

//
//  PasswordField.swift
//  ToDoApp
//
//  CAPA: Presentación (componente)
//

import SwiftUI

/// Campo de contraseña con botón para revelarla.
///
/// Al alternar entre `SecureField` y `TextField` el campo se reconstruye,
/// por eso el botón devuelve el foco cuando estaba activo.
///
/// El botón del ojo es la única razón por la que este componente necesita
/// `@FocusState.Binding`: al cambiar de tipo de campo, SwiftUI destruye el
/// control anterior y el nuevo nace sin foco. Sin devolverlo, la persona
/// escribe un carácter, toca el ojo y el teclado se cierra de golpe.
struct PasswordField: View {
    @Binding var password: String
    @Binding var isVisible: Bool
    let isFocused: Bool
    let isInvalid: Bool
    let onSubmit: () -> Void

    @FocusState.Binding var focusedField: LoginField?

    var body: some View {
        FieldShell(label: "Contraseña", isFocused: isFocused, isInvalid: isInvalid) {
            HStack(spacing: 11) {
                Image(systemName: "lock")
                    .font(.system(size: 15))
                    .foregroundStyle(Theme.inkSoft)
                    .frame(width: 20)

                ZStack(alignment: .leading) {
                    if password.isEmpty {
                        // El mínimo se interpola desde la política: el texto
                        // de ayuda y la validación nunca pueden contradecirse.
                        PlaceholderText("Mínimo \(PasswordPolicy.minimumLength) caracteres")
                    }

                    input
                        .focused($focusedField, equals: .password)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.go) // la tecla dice "ir": es la última acción
                        .onSubmit(onSubmit)
                        .foregroundStyle(Theme.ink)
                        .accessibilityLabel("Contraseña")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))

                visibilityButton
            }
        }
    }

    /// `@ViewBuilder` permite que la propiedad devuelva dos tipos distintos
    /// según la condición, algo que `some View` por sí solo no permite.
    @ViewBuilder
    private var input: some View {
        if isVisible {
            TextField("", text: $password)   // texto legible
        } else {
            SecureField("", text: $password) // puntos, sin capturas ni autocompletado
        }
    }

    private var visibilityButton: some View {
        Button {
            // Se guarda el foco ANTES de alternar: después del cambio, el
            // binding ya no refleja la situación real del control destruido.
            let wasFocused = focusedField == .password
            isVisible.toggle()

            if wasFocused {
                // Espera de 40 ms: el campo nuevo todavía no existe cuando
                // este closure termina. Es un ajuste empírico al ciclo de
                // actualización; asignar el foco antes no tendría efecto.
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(40))
                    focusedField = .password
                }
            }
        } label: {
            Image(systemName: isVisible ? "eye.slash" : "eye")
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSoft)
                // 30×30 es el mínimo táctil recomendado para un icono suelto
                // dentro de un campo (el área real es algo mayor por el padding).
                .frame(width: 30, height: 30)
                // `contentShape` hace que TODA esa caja sea tocable, no solo
                // el trazo del icono. Sin esto hay que apuntar con precisión.
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain) // evita el tinte azul del botón por defecto
        // La etiqueta cambia con el estado: el icono cambia, el significado
        // también, y VoiceOver debe decir lo que ocurrirá al tocarlo.
        .accessibilityLabel(isVisible ? "Ocultar contraseña" : "Mostrar contraseña")
    }
}

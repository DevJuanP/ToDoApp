//
//  PasswordField.swift
//  ToDoApp
//

import SwiftUI

/// Campo de contraseña con botón para revelarla.
///
/// Al alternar entre `SecureField` y `TextField` el campo se reconstruye,
/// por eso el botón devuelve el foco cuando estaba activo.
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
                        PlaceholderText("Mínimo \(PasswordPolicy.minimumLength) caracteres")
                    }

                    input
                        .focused($focusedField, equals: .password)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.go)
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

    @ViewBuilder
    private var input: some View {
        if isVisible {
            TextField("", text: $password)
        } else {
            SecureField("", text: $password)
        }
    }

    private var visibilityButton: some View {
        Button {
            let wasFocused = focusedField == .password
            isVisible.toggle()

            if wasFocused {
                Task { @MainActor in
                    try? await Task.sleep(for: .milliseconds(40))
                    focusedField = .password
                }
            }
        } label: {
            Image(systemName: isVisible ? "eye.slash" : "eye")
                .font(.system(size: 15))
                .foregroundStyle(Theme.inkSoft)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isVisible ? "Ocultar contraseña" : "Mostrar contraseña")
    }
}

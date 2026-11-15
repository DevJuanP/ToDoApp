//
//  EmailField.swift
//  ToDoApp
//

import SwiftUI

/// Campo de correo con su teclado, autocorrección y navegación.
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
                    .frame(width: 20)

                ZStack(alignment: .leading) {
                    if email.isEmpty {
                        PlaceholderText("tu@correo.com")
                    }

                    TextField("", text: $email)
                        .focused($focusedField, equals: .email)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .submitLabel(.next)
                        .onSubmit(onSubmit)
                        .foregroundStyle(Theme.ink)
                        .accessibilityLabel("Correo electrónico")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 17))
            }
        }
    }
}

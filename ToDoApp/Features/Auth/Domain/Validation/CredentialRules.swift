//
//  CredentialRules.swift
//  ToDoApp
//

import Foundation

/// El correo no puede quedar vacío.
struct RequiredEmailRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        guard credentials.normalizedEmail.isEmpty else { return nil }
        return LoginIssue(message: "Escribe tu correo para continuar.", field: .email)
    }
}

/// El correo debe tener forma de correo.
struct EmailFormatRule: ValidationRule {
    private static let pattern = #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#

    func issue(in credentials: Credentials) -> LoginIssue? {
        let email = credentials.normalizedEmail
        guard !email.isEmpty else { return nil }

        let isValid = email.range(of: Self.pattern, options: .regularExpression) != nil
        guard !isValid else { return nil }

        return LoginIssue(message: "Ese correo no parece válido.", field: .email)
    }
}

/// La contraseña no puede quedar vacía.
struct RequiredPasswordRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        guard credentials.password.isEmpty else { return nil }
        return LoginIssue(message: "Escribe tu contraseña.", field: .password)
    }
}

/// La contraseña debe alcanzar el mínimo de la política.
struct MinimumPasswordLengthRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        let password = credentials.password
        guard !password.isEmpty, password.count < PasswordPolicy.minimumLength else { return nil }

        return LoginIssue(
            message: "La contraseña necesita al menos \(PasswordPolicy.minimumLength) caracteres.",
            field: .password
        )
    }
}

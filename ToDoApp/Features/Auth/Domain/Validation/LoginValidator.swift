//
//  LoginValidator.swift
//  ToDoApp
//

/// Validador compuesto: recorre reglas en orden y se detiene en la primera que falla.
///
/// El orden importa y está en un solo lugar legible.
struct LoginValidator: CredentialValidating {
    let rules: [any ValidationRule]

    func firstIssue(in credentials: Credentials) -> LoginIssue? {
        for rule in rules {
            if let issue = rule.issue(in: credentials) {
                return issue
            }
        }
        return nil
    }
}

extension LoginValidator {
    /// Configuración por defecto de la app.
    static let `default` = LoginValidator(rules: [
        RequiredEmailRule(),
        EmailFormatRule(),
        RequiredPasswordRule(),
        MinimumPasswordLengthRule()
    ])
}

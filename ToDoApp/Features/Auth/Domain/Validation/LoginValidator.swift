//
//  LoginValidator.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Validador compuesto: recorre reglas en orden y se detiene en la primera que falla.
///
/// Este es el **patrón Composite** aplicado a validación. El truco es que
/// `LoginValidator` cumple el mismo protocolo que las reglas individuales
/// (`CredentialValidating` devuelve un `LoginIssue?`, igual que cada
/// `ValidationRule`). Eso significa que un validador podría contener otros
/// validadores y componer jerarquías sin cambiar nada.
///
/// ¿Por qué se detiene en la primera?
/// Porque mostrar tres errores a la vez en un formulario de dos campos
/// abruma, y porque el orden del array expresa prioridad: primero se corrige
/// el correo, después la contraseña. Un problema a la vez, uno por vez.
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
    ///
    /// El orden importa y está escrito en un solo lugar legible. Esta lista
    /// es el punto de extensión: para endurecer la política no se toca
    /// ninguna regla existente ni la vista, solo se agrega un elemento aquí.
    ///
    ///     static let `default` = LoginValidator(rules: [
    ///         RequiredEmailRule(),
    ///         EmailFormatRule(),
    ///         DisposableEmailRule(),   // ← nueva regla, cero cambios en lo anterior
    ///         RequiredPasswordRule(),
    ///         MinimumPasswordLengthRule()
    ///     ])
    ///
    /// `default` va entre backticks porque es palabra reservada; así el uso
    /// se lee `LoginValidator.default` sin renombrar nada.
    static let `default` = LoginValidator(rules: [
        RequiredEmailRule(),
        EmailFormatRule(),
        RequiredPasswordRule(),
        MinimumPasswordLengthRule()
    ])
}

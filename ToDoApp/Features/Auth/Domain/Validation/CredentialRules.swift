//
//  CredentialRules.swift
//  ToDoApp
//
//  CAPA: Dominio
//

import Foundation

// Este archivo agrupa las cuatro reglas concretas. Cada una es minúscula
// y tiene una única razón para cambiar, que es el principio de
// **Responsabilidad Única** aplicado a la escala más pequeña posible.
//
// Lee el sufijo de cada nombre como una frase: "RequiredEmailRule" se lee
// "regla de correo requerido". Los nombres describen la política de negocio,
// no el mecanismo (`CheckEmptyStringRule` sería peor: describe el cómo).

/// El correo no puede quedar vacío.
///
/// Nota: `guard` con la condición "válida" y `return nil` arriba (salida
/// temprana) mantiene el camino feliz sin indentación. Es el estilo que
/// Swift favorece y evita el clásico `if` anidado.
struct RequiredEmailRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        guard credentials.normalizedEmail.isEmpty else { return nil }
        return LoginIssue(message: "Escribe tu correo para continuar.", field: .email)
    }
}

/// El correo debe tener forma de correo.
///
/// El patrón vive en una constante `static` por dos razones: se compila una
/// vez y, sobre todo, tiene `private` para que nadie fuera de esta regla
/// dependa de este regex concreto. Si mañana se cambia por una validación
/// más estricta, no hay que buscar otros usos.
struct EmailFormatRule: ValidationRule {
    /// Explicación del patrón, por si hay que mantenerlo:
    ///   ^            inicio de la cadena
    ///   [^@\s]+      uno o más caracteres que no sean @ ni espacio (usuario)
    ///   @            una arroba obligatoria
    ///   [^@\s]+      uno o más caracteres que no sean @ ni espacio (dominio)
    ///   \.           un punto literal
    ///   [A-Za-z]{2,} extensión de al menos dos letras
    ///   $            fin de la cadena
    ///
    /// Se usa `#"..."#` (raw string) para no tener que escapar cada `\`.
    private static let pattern = #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#

    func issue(in credentials: Credentials) -> LoginIssue? {
        let email = credentials.normalizedEmail

        // Si está vacío, esa es responsabilidad de `RequiredEmailRule`.
        // Cada regla reporta solo su propio problema: así el mensaje que ve
        // la persona corresponde exactamente al primer fallo real.
        guard !email.isEmpty else { return nil }

        let isValid = email.range(of: Self.pattern, options: .regularExpression) != nil
        guard !isValid else { return nil }

        return LoginIssue(message: "Ese correo no parece válido.", field: .email)
    }
}

/// La contraseña no puede quedar vacía.
///
/// Está separada del largo mínimo a propósito: "vacío" y "demasiado corta"
/// son mensajes distintos y el segundo solo tiene sentido si hay algo escrito.
/// Fusionarlas daría "necesita al menos 6 caracteres" a quien no escribió nada,
/// que es un mensaje confuso.
struct RequiredPasswordRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        guard credentials.password.isEmpty else { return nil }
        return LoginIssue(message: "Escribe tu contraseña.", field: .password)
    }
}

/// La contraseña debe alcanzar el mínimo de la política.
///
/// Observa que no hay ningún `6` en esta regla: lee de `PasswordPolicy`.
/// Y el mensaje lo interpola, así que si la política cambia, el texto que ve
/// la persona cambia con ella, sin edición adicional.
struct MinimumPasswordLengthRule: ValidationRule {
    func issue(in credentials: Credentials) -> LoginIssue? {
        let password = credentials.password

        // Doble guarda intencional:
        //   password.isEmpty      → ese caso ya lo cubre RequiredPasswordRule
        //   password.count >= min → la regla se cumple, no hay nada que reportar
        guard !password.isEmpty, password.count < PasswordPolicy.minimumLength else { return nil }

        return LoginIssue(
            message: "La contraseña necesita al menos \(PasswordPolicy.minimumLength) caracteres.",
            field: .password
        )
    }
}

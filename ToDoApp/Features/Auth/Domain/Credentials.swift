//
//  Credentials.swift
//  ToDoApp
//

import Foundation

/// Credenciales tal como las escribe la persona en el formulario.
///
/// Es un objeto de valor: sin identidad, sin efectos, fácil de comparar y de probar.
struct Credentials: Equatable {
    let email: String
    let password: String

    /// El correo sin espacios accidentales.
    ///
    /// La contraseña no se normaliza: los espacios pueden ser parte de ella.
    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

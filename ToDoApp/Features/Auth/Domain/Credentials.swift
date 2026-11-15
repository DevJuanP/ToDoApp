//
//  Credentials.swift
//  ToDoApp
//
//  CAPA: Dominio
//

import Foundation

/// Credenciales tal como las escribe la persona en el formulario.
///
/// ¿Por qué existe este tipo en vez de dos `String` sueltas?
///
/// 1. **Un solo argumento en vez de dos.** Las reglas de validación y el
///    servicio de autenticación reciben `Credentials`, no `(email, password)`.
///    Con dos parámetros sueltos es fácil invertirlos por error al llamar.
///
/// 2. **Cohesión.** Si mañana se agrega un "recordarme", se añade aquí y
///    todos los que ya reciben `Credentials` lo obtienen sin cambiar firmas.
///
/// 3. **Es un objeto de valor.** `Equatable` y sin identidad: dos credenciales
///    con los mismos datos son la misma cosa. Eso lo hace trivial de comparar
///    en tests (`XCTAssertEqual`).
///
/// Nota de diseño: es un `struct`, no una `class`. Sin herencia ni referencia
/// compartida, nadie puede mutar las credenciales de otro por accidente.
struct Credentials: Equatable {
    let email: String
    let password: String

    /// El correo sin espacios accidentales.
    ///
    /// La normalización vive aquí y no en la vista por una razón concreta:
    /// hay varios puntos que necesitan el correo limpio (validar, comparar,
    /// autenticar). Si cada uno hiciera su propio `trimmingCharacters`,
    /// tarde o temprano uno olvidaría hacerlo y las reglas discreparían.
    ///
    /// En cambio, `password` NO se normaliza: los espacios pueden ser parte
    /// legítima de una contraseña, y recortarlos rompería credenciales válidas.
    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

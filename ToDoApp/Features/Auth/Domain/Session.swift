//
//  Session.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Sesión abierta tras un acceso correcto.
///
/// Es deliberadamente pequeña: hoy solo guarda el correo. Un token real
/// o una fecha de expiración se añadirían aquí, y todas las vistas que
/// ya reciben `Session` seguirían compilando sin cambios.
///
/// `Equatable` permite comparar sesiones en tests y detectar cuándo la
/// sesión realmente cambió (útil si algún día se usa con `onChange`).
struct Session: Equatable {
    let email: String
}

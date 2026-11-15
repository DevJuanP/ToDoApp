//
//  LoginField.swift
//  ToDoApp
//

/// Campos del formulario de acceso.
///
/// Vive en el dominio porque tanto la validación como la interfaz
/// necesitan nombrar el campo que causó un error.
enum LoginField: Hashable {
    case email
    case password
}

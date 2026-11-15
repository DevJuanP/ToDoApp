//
//  LoginField.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Campos del formulario de acceso.
///
/// ¿Por qué un `enum` en el dominio y no en la vista?
///
/// Porque tanto la **validación** como la **interfaz** necesitan nombrar el
/// campo que causó un error: el validador dice "el problema está en el correo"
/// y la vista usa esa respuesta para pintar el borde en rojo y mover el foco.
/// Si el enum viviera dentro de `LoginView`, el dominio tendría que depender
/// de la presentación — la flecha de dependencias apuntaría al revés.
///
/// `Hashable` es un requisito técnico de `@FocusState`: SwiftUI identifica
/// cada campo enfocable por un valor hashable.
enum LoginField: Hashable {
    case email
    case password
}

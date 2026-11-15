//
//  LoginIssue.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Un problema concreto del formulario: qué pasó y dónde.
///
/// Antes esta información viajaba como una tupla `(String, LoginField)`.
/// El problema de una tupla es que no se explica: en el punto de uso hay
/// que recordar qué era `.0` y qué era `.1`.
///
/// Con un tipo nombrado, el código se lee solo:
///     issue.message   // el texto para la persona
///     issue.field     // dónde señalar
///
/// Además, mañana se puede enriquecer sin tocar a quienes ya lo consumen:
/// por ejemplo `severity` o `recoverySuggestion`. Eso es lo que hace que un
/// tipo nombrado envejezca mejor que una tupla.
struct LoginIssue: Equatable {
    let message: String
    let field: LoginField
}

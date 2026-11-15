//
//  LoginIssue.swift
//  ToDoApp
//

/// Un problema concreto del formulario: qué pasó y dónde.
///
/// Reemplaza la tupla `(String, LoginField)` que antes viajaba sin nombre.
struct LoginIssue: Equatable {
    let message: String
    let field: LoginField
}

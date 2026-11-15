//
//  CredentialValidating.swift
//  ToDoApp
//

/// Contrato de validación que consume la pantalla.
///
/// Inversión de dependencias: la interfaz depende de esta abstracción,
/// nunca de las reglas concretas.
protocol CredentialValidating {
    /// El primer problema encontrado, en el orden en que se revisan las reglas.
    func firstIssue(in credentials: Credentials) -> LoginIssue?
}

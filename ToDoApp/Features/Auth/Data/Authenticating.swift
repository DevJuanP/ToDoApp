//
//  Authenticating.swift
//  ToDoApp
//

/// Contrato de autenticación que consume la pantalla.
///
/// Permitiría -sin tocar la vista- cambiar `StubAuthService` por una
/// implementación con red, sin más cambio que el punto de inyección.
protocol Authenticating {
    func signIn(with credentials: Credentials) async throws -> Session
}

//
//  StubAuthService.swift
//  ToDoApp
//

import Foundation

/// Implementación de ejemplo: no hay servidor, así que acepta lo ya validado
/// y simula la latencia de la red para que el estado "Verificando…" sea visible.
struct StubAuthService: Authenticating {
    /// Latencia simulada.
    var networkDelay: Duration = .milliseconds(850)

    func signIn(with credentials: Credentials) async throws -> Session {
        try await Task.sleep(for: networkDelay)
        return Session(email: credentials.normalizedEmail)
    }
}

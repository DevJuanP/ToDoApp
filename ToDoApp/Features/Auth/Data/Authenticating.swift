//
//  Authenticating.swift
//  ToDoApp
//
//  CAPA: Datos (abstracción)
//

/// Contrato de autenticación que consume la pantalla.
///
/// Mismo principio de **Inversión de Dependencias** que `CredentialValidating`,
/// pero aplicado al acceso a datos. `LoginViewModel` pide "algo que sepa
/// iniciar sesión", no "una clase que haga fetch".
///
/// Lo importante está en que el protocolo usa `async throws`: la firma ya
/// admite que esto puede tardar y puede fallar. Por eso la vista tiene un
/// estado "Verificando…" y un camino de error, aunque la implementación de
/// hoy (`StubAuthService`) nunca falle. Cuando llegue el backend real, la
/// pantalla ya está preparada — no habrá que rediseñarla.
///
/// Cambiar de simulación a servidor real es literalmente esto:
///
///     LoginView(authService: APIAuthService(baseURL: ...)) { session in ... }
///
/// La vista y el view model no se tocan.
protocol Authenticating {
    func signIn(with credentials: Credentials) async throws -> Session
}

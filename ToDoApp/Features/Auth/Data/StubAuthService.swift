//
//  StubAuthService.swift
//  ToDoApp
//
//  CAPA: Datos (implementación)
//

import Foundation

/// Implementación de ejemplo: no hay servidor, así que acepta lo ya validado
/// y simula la latencia de la red para que el estado "Verificando…" sea visible.
///
/// Detalles que vale la pena estudiar:
///
/// 1. **`networkDelay` es inyectable con valor por defecto.** En la app se usa
///    el valor de 850 ms; en un test se puede pasar `.zero` y la prueba corre
///    al instante. Esto es lo que hace testeable algo que "espera".
///
/// 2. **Cumple el protocolo y nada más.** No sabe de colores, ni de campos
///    inválidos, ni de texto en español para la interfaz. Solo convierte
///    credenciales en sesión. Una responsabilidad.
///
/// 3. **`try await Task.sleep` es lo que la hace `async throws`.** Si se
///    cancelara la tarea (por ejemplo, la persona sale de la pantalla), el
///    `sleep` lanza y la cadena de `try` propaga la cancelación. Eso es
///    correcto: no queremos completar un login que ya nadie espera.
struct StubAuthService: Authenticating {
    /// Latencia simulada de red.
    var networkDelay: Duration = .milliseconds(850)

    func signIn(with credentials: Credentials) async throws -> Session {
        try await Task.sleep(for: networkDelay)
        return Session(email: credentials.normalizedEmail)
    }
}

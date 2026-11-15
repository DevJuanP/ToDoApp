//
//  AuthSessionStore.swift
//  ToDoApp
//
//  CAPA: Estado
//

// Importante: `import Combine`, no `import SwiftUI`.
//
// Podría parecer que `SwiftUI` basta porque normalmente reexporta `Combine`
// (y de ahí vienen `ObservableObject` y `@Published`). Pero este proyecto
// tiene activado `SWIFT_UPCOMING_FEATURE_MEMBER_IMPORT_VISIBILITY = YES`,
// una opción del modo Swift 6 que **desactiva las reexportaciones
// transitivas**: cada archivo debe importar el módulo que declara lo que usa.
//
// Con esa opción, escribir `import SwiftUI` provoca:
//     Type 'AuthSessionStore' does not conform to protocol 'ObservableObject'
//
// El error engaña porque la conformidad sí está declarada; el problema es que
// el compilador no ve el protocolo. Importar `Combine` explícitamente lo
// resuelve, y además es más honesto: esta clase no dibuja nada, así que no
// tiene por qué depender de SwiftUI.
import Combine

/// Estado de sesión de la app.
///
/// Separa "quién está dentro" de la pantalla que lo pide: `ContentView`
/// se limita a observar y a dibujar una rama u otra.
///
/// Esto es **Responsabilidad Única** aplicada a la raíz de la app. Antes,
/// `ContentView` guardaba `@State private var signedInEmail` y además
/// decidía transiciones y diseño. Ahora:
///
///     - `AuthSessionStore`  sabe quién está dentro
///     - `ContentView`       sabe qué mostrar según eso
///
/// El día que la sesión deba persistir (Keychain, `UserDefaults`) o
/// expirar, se cambia únicamente esta clase.
@MainActor
final class AuthSessionStore: ObservableObject {
    /// `private(set)` significa: todos pueden leer si hay sesión, pero solo
    /// esta clase puede cambiarla. Se evita que una vista haga
    /// `store.session = algoInventado` desde fuera.
    @Published private(set) var session: Session?

    func start(_ session: Session) {
        self.session = session
    }

    func end() {
        session = nil
    }
}

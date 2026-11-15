//
//  AuthSessionStore.swift
//  ToDoApp
//

import Combine

/// Estado de sesión de la app.
///
/// Separa "quién está dentro" de la pantalla que lo pide: `ContentView`
/// se limita a observar y a dibujar una rama u otra.
@MainActor
final class AuthSessionStore: ObservableObject {
    @Published private(set) var session: Session?

    func start(_ session: Session) {
        self.session = session
    }

    func end() {
        session = nil
    }
}

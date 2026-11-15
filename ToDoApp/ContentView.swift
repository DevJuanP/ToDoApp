//
//  ContentView.swift
//  ToDoApp
//
//  Created by XCODE on 12/11/26.
//

import SwiftUI

/// Raíz de la app: elige qué pantalla se ve según el estado de sesión.
///
/// No contiene diseño ni lógica de acceso; solo compone.
struct ContentView: View {
    @StateObject private var sessionStore = AuthSessionStore()

    var body: some View {
        ZStack {
            AppBackdrop()

            if let session = sessionStore.session {
                HomePlaceholderView(session: session) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                        sessionStore.end()
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                LoginView { session in
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.88)) {
                        sessionStore.start(session)
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 1.02)))
            }
        }
        .tint(Theme.pine)
    }
}

// MARK: - Preview

#Preview("Claro") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Oscuro") {
    ContentView()
        .preferredColorScheme(.dark)
}

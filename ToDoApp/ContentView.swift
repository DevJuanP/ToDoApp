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
///
/// **Esto es Single Responsibility aplicado a la raíz.** La versión original
/// de este archivo tenía 573 líneas: el tema, la validación, la simulación de
/// red, nueve vistas y el estado de sesión. Ahora tiene una decisión que
/// tomar y la toma en cuatro líneas.
///
/// La estructura `if let session` sobre un estado observable es el patrón
/// estándar de sesión en SwiftUI: una sola fuente de verdad (`sessionStore`),
/// y la interfaz es una función de ese estado. No hay `NavigationStack` ni
/// botón de retroceso porque no hay nada detrás del login.
struct ContentView: View {
    /// `@StateObject` porque esta vista **es dueña** del store: debe sobrevivir
    /// a las reevaluaciones. Si fuera `@ObservedObject` creado aquí, cada
    /// redibujado podría recrearlo y se perdería la sesión.
    @StateObject private var sessionStore = AuthSessionStore()

    var body: some View {
        ZStack {
            // El fondo vive aquí, no en cada pantalla: así el cambio de una
            // a otra no produce un salto de color, porque la capa de fondo
            // nunca se destruye.
            AppBackdrop()

            if let session = sessionStore.session {
                HomePlaceholderView(session: session) {
                    // `withAnimation` envuelve el cambio de estado para que
                    // la transición se ejecute; sin él, el `transition` de la
                    // vista no tendría animación que aplicar.
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                        sessionStore.end()
                    }
                }
                // Al entrar, la pantalla nueva crece desde algo más pequeña:
                // llega "hacia delante".
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                LoginView { session in
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.88)) {
                        sessionStore.start(session)
                    }
                }
                // Al salir, el login se aleja (escala 1.02): el gesto de
                // "lo dejo atrás" se lee mejor que una simple desaparición.
                // Los dos `scale` son opuestos a propósito; así la dirección
                // del cambio se percibe aunque la duración sea la misma.
                .transition(.opacity.combined(with: .scale(scale: 1.02)))
            }
        }
        // `tint` fija el color de acento del sistema para todo el subárbol
        // (cursor, selección, controles). Se declara una vez aquí en lugar de
        // en cada vista.
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

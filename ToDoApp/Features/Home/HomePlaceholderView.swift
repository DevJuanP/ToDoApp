//
//  HomePlaceholderView.swift
//  ToDoApp
//
//  CAPA: Feature Home (pantalla)
//

import SwiftUI

/// Pantalla provisional tras iniciar sesión.
///
/// Ocupa el lugar del listado real de pendientes.
///
/// Existe para que el login no termine en un callejón: sin ella, validar
/// las credenciales no llevaría a ninguna parte y no se podría comprobar el
/// flujo completo. Cuando llegue la lista de tareas, se sustituye esta vista
/// y **nada más cambia**: `ContentView` ya pasa la sesión y el cierre.
///
/// Recibe `session` y `onSignOut` como datos y closure, no un store: así
/// esta pantalla no sabe de dónde viene la sesión ni qué hace exactamente
/// cerrarla. Se puede previsualizar con datos inventados, como abajo.
struct HomePlaceholderView: View {
    private let session: Session
    private let onSignOut: () -> Void

    init(session: Session, onSignOut: @escaping () -> Void) {
        self.session = session
        self.onSignOut = onSignOut
    }

    var body: some View {
        VStack(spacing: 0) {
            // Dos `Spacer` que empujan el contenido al centro y el botón
            // al pie, sin necesidad de calcular alturas.
            Spacer()

            BrandMark(size: 56)

            Text("Sesión iniciada")
                .font(.system(.title, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                .padding(.top, 24)
                .accessibilityAddTraits(.isHeader)

            Text(session.email)
                .font(.subheadline)
                .foregroundStyle(Theme.inkSoft)
                // Un correo largo podría desbordar. En vez de encogerlo,
                // se corta por el medio: así se ven el inicio y el dominio,
                // que es lo que identifica la cuenta.
                .lineLimit(1)
                .truncationMode(.middle)
                .padding(.top, 8)
                .padding(.horizontal, 36)

            Text("Aquí empezará tu lista de pendientes.")
                .font(.footnote)
                .foregroundStyle(Theme.inkSoft)
                .padding(.top, 6)

            Spacer()

            SecondaryButton(title: "Cerrar sesión", action: onSignOut)
                .padding(.horizontal, 28)
                .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
    }
}

/// Preview con una sesión inventada: no hace falta autenticarse para revisar
/// el diseño de esta pantalla. Es el beneficio de recibir datos en vez de
/// leerlos de un singleton.
#Preview {
    HomePlaceholderView(
        session: Session(email: "alumno@cibertec.edu.pe"),
        onSignOut: {}
    )
}

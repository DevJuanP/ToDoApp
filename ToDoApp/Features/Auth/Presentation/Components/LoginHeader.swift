//
//  LoginHeader.swift
//  ToDoApp
//
//  CAPA: Presentación (componente)
//

import SwiftUI

/// Titular y subtítulo de la pantalla de acceso.
///
/// Extraído a su propio archivo por una razón concreta: el titular es la
/// pieza con más carga de diseño de la pantalla (serif, tamaño grande, dos
/// pesos distintos). Aislarlo permite ajustarlo sin tocar el layout del
/// formulario, y el resto de `LoginView` queda más fácil de leer.
///
/// Detalle tipográfico: se usa `design: .serif` (New York en iOS) frente al
/// sans del cuerpo. Es el único lugar de la app con serif, y por eso funciona
/// como firma: marca dónde empieza la conversación.
struct LoginHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hola de nuevo")
                .font(.system(.largeTitle, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                // Permite que el titular use dos líneas si el tamaño de texto
                // del sistema es muy grande, en vez de comprimirse.
                .fixedSize(horizontal: false, vertical: true)
                // Es el encabezado de la pantalla: con este trait, el rotor de
                // VoiceOver permite navegar por encabezados en vez de leer
                // todo linealmente.
                .accessibilityAddTraits(.isHeader)

            Text("Entra para retomar los pendientes de hoy.")
                .font(.callout)
                .foregroundStyle(Theme.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

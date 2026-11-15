//
//  PrimaryButton.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Acción principal de una pantalla: ancho completo, tinta, con estado de carga.
///
/// **Por qué existe un componente en vez de un `Button` en la vista.**
/// Este botón tiene seis decisiones dentro (alto mínimo, esquinas continuas,
/// degradado, icono, estado de carga, etiqueta accesible). Repetirlas en cada
/// pantalla garantiza que con el tiempo se desvíen. Como componente, la
/// decisión se toma una vez.
///
/// `loadingTitle` y `systemImage` son opcionales con valor por defecto para
/// que el caso simple no pase parámetros vacíos.
struct PrimaryButton: View {
    let title: String
    var loadingTitle: String?
    let isLoading: Bool
    var systemImage: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    // El indicador y el texto conviven: cambiar el texto solo
                    // ya comunica que algo pasa, pero el spinner añade "está
                    // trabajando", no "se rompió".
                    ProgressView()
                        .controlSize(.small)
                        .tint(Theme.onInk)

                    Text(loadingTitle ?? title)
                } else {
                    Text(title)

                    if let systemImage {
                        Image(systemName: systemImage)
                            // Peso semibold como el texto, para que la flecha
                            // no se vea más fina que las letras.
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Theme.onInk)
            // `minHeight: 56` garantiza el área táctil mínima de 44 pt con aire,
            // incluso si el texto cambia de tamaño con Dynamic Type.
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        // Degradado vertical muy leve: hace que la superficie
                        // se lea como una pieza con luz, no como un rectángulo
                        // de color plano.
                        LinearGradient(
                            colors: [Theme.inkRaised, Theme.ink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            // El `contentShape` amplía la zona tocable a todo el rectángulo,
            // incluidos los píxeles transparentes de las esquinas redondeadas.
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .opacity(isLoading ? 0.9 : 1)
        }
        .buttonStyle(PressButtonStyle())
        // Desactivado mientras carga: evita el doble envío desde la interfaz,
        // en paralelo a la guarda que el view model hace por su cuenta.
        .disabled(isLoading)
        // Etiqueta fija: si se anunciara el texto visible, VoiceOver diría
        // "Verificando…" y no quedaría claro qué acción se está ejecutando.
        .accessibilityLabel(title)
    }
}

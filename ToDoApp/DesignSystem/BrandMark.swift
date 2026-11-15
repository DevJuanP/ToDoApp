//
//  BrandMark.swift
//  ToDoApp
//
//  CAPA: Design System
//

import SwiftUI

/// Logotipo de la app: cuadrado verde con check.
///
/// Es un logotipo dibujado con formas, no una imagen importada. Ventajas:
/// escala a cualquier tamaño sin perder nitidez (de 40 pt en la cabecera a
/// 56 pt en la pantalla de sesión), toma los colores del tema y admite modo
/// oscuro sin un segundo asset.
///
/// `size` tiene valor por defecto para que el caso común —la cabecera— no
/// tenga que pasar nada, pero cualquier pantalla pueda pedir otro tamaño.
struct BrandMark: View {
    var size: CGFloat = 40

    private let check = CheckGlyph()

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
            .fill(
                // Degradado diagonal sutil: da volumen sin recurrir a sombras,
                // que sobre un fondo claro se ensucian.
                LinearGradient(
                    colors: [Theme.pine, Theme.pineDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                check
                    .stroke(
                        Theme.onPine,
                        // Todos los trazos derivan de `size`, así que el check
                        // guarda la misma proporción a cualquier escala.
                        // `.round` en ambos extremos evita puntas afiladas,
                        // que se ven toscas a tamaños pequeños.
                        style: StrokeStyle(lineWidth: size * 0.105, lineCap: .round, lineJoin: .round)
                    )
                    // El padding deja aire alrededor del check; sin él, el
                    // trazo tocaría los bordes del cuadrado.
                    .padding(size * 0.27)
            )
            // Es decorativo: el nombre "ToDoApp" ya se anuncia por separado
            // en `BrandHeader`, así que VoiceOver no debe leerlo.
            .accessibilityHidden(true)
    }
}

//
//  PrimaryButton.swift
//  ToDoApp
//

import SwiftUI

/// Acción principal de una pantalla: ancho completo, tinta, con estado de carga.
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
                    ProgressView()
                        .controlSize(.small)
                        .tint(Theme.onInk)

                    Text(loadingTitle ?? title)
                } else {
                    Text(title)

                    if let systemImage {
                        Image(systemName: systemImage)
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Theme.onInk)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Theme.inkRaised, Theme.ink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .opacity(isLoading ? 0.9 : 1)
        }
        .buttonStyle(PressButtonStyle())
        .disabled(isLoading)
        .accessibilityLabel(title)
    }
}

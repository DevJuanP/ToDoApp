//
//  HomePlaceholderView.swift
//  ToDoApp
//

import SwiftUI

/// Pantalla provisional tras iniciar sesión.
///
/// Ocupa el lugar del listado real de pendientes.
struct HomePlaceholderView: View {
    private let session: Session
    private let onSignOut: () -> Void

    init(session: Session, onSignOut: @escaping () -> Void) {
        self.session = session
        self.onSignOut = onSignOut
    }

    var body: some View {
        VStack(spacing: 0) {
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

#Preview {
    HomePlaceholderView(
        session: Session(email: "alumno@cibertec.edu.pe"),
        onSignOut: {}
    )
}

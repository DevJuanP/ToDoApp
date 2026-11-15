//
//  LoginView.swift
//  ToDoApp
//

import SwiftUI

/// Pantalla de acceso.
///
/// Sin `NavigationStack` y sin botón de retroceso: no hay nada detrás.
/// La vista compone piezas y reenvía eventos; no valida ni autentica.
struct LoginView: View {
    @StateObject private var viewModel: LoginViewModel
    @FocusState private var focusedField: LoginField?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasAppeared = false

    init(
        validator: CredentialValidating = LoginValidator.default,
        authService: Authenticating = StubAuthService(),
        onSignedIn: @escaping (Session) -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: LoginViewModel(
                validator: validator,
                authService: authService,
                onSignedIn: onSignedIn
            )
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                BrandHeader()
                    .padding(.top, LoginLayout.brandTopPadding)

                LoginHeader()
                    .padding(.top, LoginLayout.headerTopPadding)

                fields
                    .padding(.top, LoginLayout.fieldsTopPadding)

                PrimaryButton(
                    title: "Iniciar sesión",
                    loadingTitle: "Verificando…",
                    isLoading: viewModel.isSubmitting,
                    systemImage: "arrow.right",
                    action: submit
                )
                .padding(.top, LoginLayout.actionTopPadding)

                Text("Vista de ejemplo: aún no hay servidor conectado.")
                    .font(.footnote)
                    .foregroundStyle(Theme.inkSoft)
                    .padding(.top, LoginLayout.footerTopPadding)
            }
            .padding(.horizontal, LoginLayout.horizontalPadding)
            .padding(.bottom, LoginLayout.bottomPadding)
            .frame(maxWidth: LoginLayout.contentMaxWidth)
            .frame(maxWidth: .infinity, minHeight: 0)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared || reduceMotion ? 0 : LoginLayout.appearOffset)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: hasAppeared)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .sensoryFeedback(.error, trigger: viewModel.shakeCount)
        .sensoryFeedback(.success, trigger: viewModel.successCount)
        .onAppear { hasAppeared = true }
        .onChange(of: viewModel.email) { _, _ in clearError() }
        .onChange(of: viewModel.password) { _, _ in clearError() }
        .onChange(of: viewModel.focusedField) { _, newValue in
            if focusedField != newValue { focusedField = newValue }
        }
        .onChange(of: focusedField) { _, newValue in
            if viewModel.focusedField != newValue { viewModel.focusedField = newValue }
        }
        .animation(.easeOut(duration: 0.22), value: viewModel.errorMessage)
    }

    // MARK: Campos

    private var fields: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 18) {
                EmailField(
                    email: $viewModel.email,
                    isFocused: focusedField == .email,
                    isInvalid: viewModel.invalidField == .email,
                    onSubmit: { focusedField = .password },
                    focusedField: $focusedField
                )

                PasswordField(
                    password: $viewModel.password,
                    isVisible: $viewModel.isPasswordVisible,
                    isFocused: focusedField == .password,
                    isInvalid: viewModel.invalidField == .password,
                    onSubmit: submit,
                    focusedField: $focusedField
                )
            }
            .modifier(ShakeEffect(animatableData: CGFloat(viewModel.shakeCount)))
            .animation(.linear(duration: 0.45), value: viewModel.shakeCount)

            if let message = viewModel.errorMessage {
                FormErrorLabel(message)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: Acciones

    private func submit() {
        Task { await viewModel.submit() }
    }

    private func clearError() {
        withAnimation(.easeOut(duration: 0.18)) {
            viewModel.clearError()
        }
    }
}

// MARK: - Preview

#Preview("Claro") {
    LoginView(onSignedIn: { _ in })
        .preferredColorScheme(.light)
}

#Preview("Oscuro") {
    LoginView(onSignedIn: { _ in })
        .preferredColorScheme(.dark)
}

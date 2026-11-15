//
//  LoginViewModel.swift
//  ToDoApp
//

import Combine

/// Estado y decisiones de la pantalla de acceso.
///
/// Toda la lógica del formulario vive aquí: la vista solo dibuja lo que este
/// objeto expone y le reenvía los eventos. Se puede probar sin interfaz.
@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var errorMessage: String?
    @Published private(set) var invalidField: LoginField?
    @Published private(set) var isSubmitting = false
    @Published private(set) var shakeCount = 0
    @Published private(set) var successCount = 0

    @Published var focusedField: LoginField?

    private let validator: CredentialValidating
    private let authService: Authenticating
    private let onSignedIn: (Session) -> Void

    init(
        validator: CredentialValidating = LoginValidator.default,
        authService: Authenticating = StubAuthService(),
        onSignedIn: @escaping (Session) -> Void
    ) {
        self.validator = validator
        self.authService = authService
        self.onSignedIn = onSignedIn
    }

    private var credentials: Credentials {
        Credentials(email: email, password: password)
    }

    // MARK: Eventos

    /// Envía el formulario: valida, avisa del fallo o inicia sesión.
    func submit() async {
        guard !isSubmitting else { return }

        if let issue = validator.firstIssue(in: credentials) {
            reject(with: issue)
            return
        }

        await signIn()
    }

    /// Un cambio en los campos retira el error anterior.
    func clearError() {
        guard errorMessage != nil || invalidField != nil else { return }
        errorMessage = nil
        invalidField = nil
    }

    // MARK: Detalle

    private func reject(with issue: LoginIssue) {
        errorMessage = issue.message
        invalidField = issue.field
        shakeCount += 1
        focusedField = issue.field
    }

    private func signIn() async {
        clearError()
        focusedField = nil
        isSubmitting = true

        do {
            let session = try await authService.signIn(with: credentials)
            successCount += 1
            isSubmitting = false
            onSignedIn(session)
        } catch {
            isSubmitting = false
            errorMessage = "No pudimos iniciar sesión. Inténtalo otra vez."
            invalidField = nil
            shakeCount += 1
        }
    }
}

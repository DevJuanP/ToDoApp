//
//  LoginView.swift
//  ToDoApp
//
//  CAPA: Presentación (vista)
//

import SwiftUI

/// Pantalla de acceso.
///
/// Sin `NavigationStack` y sin botón de retroceso: no hay nada detrás.
/// La vista compone piezas y reenvía eventos; no valida ni autentica.
///
/// **Este archivo es la prueba de que el refactor funcionó.** Compáralo con
/// la versión monolítica: pasó de ~570 líneas con regex y `Task.sleep` a poco
/// más de cien que solo dicen "dibuja esto aquí". Si algún día hay que
/// cambiar el diseño, este es el único archivo de la pantalla que se abre.
struct LoginView: View {

    // MARK: - Estado propio de la vista
    //
    // Solo dos cosas que son puramente visuales. Todo lo demás (campos,
    // error, carga) está en el view model. Ese reparto es el que hace que
    // SwiftUI no reevalúe medio proyecto en cada tecla.

    /// El foco se declara con `@FocusState` porque es una propiedad del
    /// sistema de entrada de SwiftUI, no un dato de negocio.
    @FocusState private var focusedField: LoginField?

    /// Controla la animación de entrada. Vive aquí y no en el view model
    /// porque no es una decisión de negocio: es cómo aparece la pantalla.
    @State private var hasAppeared = false

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// `@StateObject` (y no `@ObservedObject`) porque la vista **crea y posee**
    /// el view model. Con `@ObservedObject` SwiftUI podría recrearlo en cada
    /// reevaluación y perderíamos lo escrito en los campos.
    @StateObject private var viewModel: LoginViewModel

    /// El inicializador recibe las dependencias y las pasa al view model.
    /// Esto mantiene a `LoginView` ignorante de qué validador o servicio usa.
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
            // `spacing: 0` es deliberado: los espacios se controlan con
            // `padding` explícito desde `LoginLayout` para que el ritmo
            // vertical sea visible y ajustable en un solo lugar.
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

                // El texto es honesto a propósito: sin backend, no se puede
                // afirmar que las credenciales están protegidas.
                Text("Vista de ejemplo: aún no hay servidor conectado.")
                    .font(.footnote)
                    .foregroundStyle(Theme.inkSoft)
                    .padding(.top, LoginLayout.footerTopPadding)
            }
            .padding(.horizontal, LoginLayout.horizontalPadding)
            .padding(.bottom, LoginLayout.bottomPadding)
            // Dos `.frame` seguidos: el primero limita el ancho en iPad
            // (460 pt de lectura cómoda) y el segundo lo centra en la pantalla.
            .frame(maxWidth: LoginLayout.contentMaxWidth)
            .frame(maxWidth: .infinity, minHeight: 0)
            // Animación de entrada: de invisible y 14 pt abajo a su sitio.
            // Cualquier persona con "Reducir movimiento" activado en iOS salta
            // directamente al estado final, sin transición.
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared || reduceMotion ? 0 : LoginLayout.appearOffset)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: hasAppeared)
        }
        .scrollBounceBehavior(.basedOnSize)      // sin rebote si no hay scroll
        .scrollDismissesKeyboard(.interactively) // arrastrar cierra el teclado
        // Ambos efectos se disparan por cambio de valor, no por estado:
        // por eso el view model expone contadores y no `Bool`.
        .sensoryFeedback(.error, trigger: viewModel.shakeCount)
        .sensoryFeedback(.success, trigger: viewModel.successCount)
        .onAppear { hasAppeared = true }
        // Al escribir, el error se retira. La animación hace que el mensaje
        // no desaparezca de golpe (que se sentiría como un parpadeo).
        .onChange(of: viewModel.email) { _, _ in clearError() }
        .onChange(of: viewModel.password) { _, _ in clearError() }
        // Sincronización bidireccional del foco.
        //
        // Hay dos fuentes de verdad para el foco: la vista (cuando la persona
        // toca un campo) y el view model (cuando decide enfocar el campo
        // inválido). Sin estos dos `onChange` se desincronizan y el borde
        // verde de "enfocado" puede quedar en el campo equivocado.
        // Las guardas `if` evitan un bucle infinito de actualizaciones.
        .onChange(of: viewModel.focusedField) { _, newValue in
            if focusedField != newValue { focusedField = newValue }
        }
        .onChange(of: focusedField) { _, newValue in
            if viewModel.focusedField != newValue { viewModel.focusedField = newValue }
        }
        .animation(.easeOut(duration: 0.22), value: viewModel.errorMessage)
    }

    // MARK: - Campos

    private var fields: some View {
        VStack(alignment: .leading, spacing: 18) {
            // Este VStack interno agrupa SOLO los dos campos, porque es lo que
            // se sacude cuando hay un error. Si incluyera la etiqueta de error,
            // el mensaje también se movería y se leería peor.
            VStack(alignment: .leading, spacing: 18) {
                EmailField(
                    email: $viewModel.email,
                    isFocused: focusedField == .email,
                    isInvalid: viewModel.invalidField == .email,
                    onSubmit: { focusedField = .password }, // "siguiente" salta a contraseña
                    focusedField: $focusedField
                )

                PasswordField(
                    password: $viewModel.password,
                    isVisible: $viewModel.isPasswordVisible,
                    isFocused: focusedField == .password,
                    isInvalid: viewModel.invalidField == .password,
                    onSubmit: submit, // "ir" del teclado envía el formulario
                    focusedField: $focusedField
                )
            }
            // El desplazamiento del rechazo. `animatableData` es el contador,
            // así que cada error lo empuja de nuevo aunque el valor anterior
            // ya hubiera vuelto a cero.
            .modifier(ShakeEffect(animatableData: CGFloat(viewModel.shakeCount)))
            .animation(.linear(duration: 0.45), value: viewModel.shakeCount)

            // `if let` en lugar de `.opacity`: el mensaje se inserta y se
            // retira de verdad, así que VoiceOver lo anuncia al aparecer
            // y el layout se ajusta solo cuando existe.
            if let message = viewModel.errorMessage {
                FormErrorLabel(message)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Acciones

    /// La vista no espera: lanza la tarea.
    ///
    /// `Task { }` hereda el `@MainActor` de la vista, así que el view model
    /// sigue actualizando la interfaz en el hilo correcto.
    private func submit() {
        Task { await viewModel.submit() }
    }

    /// Envuelve el cambio en `withAnimation` para que la retirada del error
    /// sea un fundido y no un salto.
    private func clearError() {
        withAnimation(.easeOut(duration: 0.18)) {
            viewModel.clearError()
        }
    }
}

// MARK: - Preview

/// Dos previews, uno por apariencia: el tema es dinámico y conviene
/// comprobar que ambos se ven bien sin cambiar el simulador.
#Preview("Claro") {
    LoginView(onSignedIn: { _ in })
        .preferredColorScheme(.light)
}

#Preview("Oscuro") {
    LoginView(onSignedIn: { _ in })
        .preferredColorScheme(.dark)
}

//
//  LoginViewModel.swift
//  ToDoApp
//
//  CAPA: Presentación (estado y decisiones)
//

// `import Combine`, no `SwiftUI`: esta clase expone estado observable pero
// no dibuja ninguna vista. Ver la explicación completa en
// `AuthSessionStore.swift` sobre `MEMBER_IMPORT_VISIBILITY`.
import Combine

/// Estado y decisiones de la pantalla de acceso.
///
/// Toda la lógica del formulario vive aquí: la vista solo dibuja lo que este
/// objeto expone y le reenvía los eventos. Se puede probar sin interfaz.
///
/// **Esta clase es el resultado de aplicar Responsabilidad Única a la vista.**
/// Antes, `LoginView` tenía 8 variables de estado, validaba con regex, dormía
/// con `Task.sleep` y dibujaba. Ahora la vista tiene 2 variables propias
/// (foco y animación de entrada) y este objeto tiene todo lo demás.
///
/// Ventaja concreta para estudiar: aquí se puede razonar sobre el flujo de la
/// pantalla completa sin leer una sola línea de SwiftUI.
///
/// `@MainActor` es necesario porque actualiza `@Published` (estado que la
/// interfaz lee) y no queremos hacerlo desde un hilo de fondo. En este
/// proyecto además está activado `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`,
/// así que es coherente con el resto.
@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Estado que la vista puede modificar
    //
    // Estos son `var` públicos porque los campos de texto los escriben
    // directamente con `$viewModel.email` (binding bidireccional).

    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false

    /// El foco se publica aquí para que el view model pueda moverlo
    /// (por ejemplo, al campo que falló la validación) sin que la vista
    /// tenga que interpretar esa regla.
    @Published var focusedField: LoginField?

    // MARK: - Estado que la vista solo lee
    //
    // `private(set)`: la vista puede leerlos para pintar, pero no cambiarlos.
    // Si la vista pudiera hacer `viewModel.errorMessage = nil` estaríamos
    // dejando que la presentación invente estado de negocio.

    @Published private(set) var errorMessage: String?
    @Published private(set) var invalidField: LoginField?

    /// Mientras es `true`, el botón muestra "Verificando…" y queda desactivado.
    @Published private(set) var isSubmitting = false

    /// Contadores que solo existen para disparar efectos sensoriales.
    /// Se incrementan en vez de ponerse a `true` porque `sensoryFeedback`
    /// reacciona a *cambios de valor*: dos errores seguidos deben vibrar dos
    /// veces, y un `Bool` que ya está en `true` no cambia.
    @Published private(set) var shakeCount = 0
    @Published private(set) var successCount = 0

    // MARK: - Dependencias
    //
    // Las tres son abstracciones o funciones, nunca tipos concretos.
    // Esto es lo que permite probar la clase y sustituir piezas.

    private let validator: CredentialValidating
    private let authService: Authenticating
    private let onSignedIn: (Session) -> Void

    /// Las dependencias entran por el inicializador, con valores por defecto
    /// para que la app real no tenga que pasar nada. Eso se llama
    /// **inyección de dependencias por constructor** y es lo que hace que
    /// un test pueda escribir:
    ///
    ///     LoginViewModel(
    ///         validator: AlwaysFailingValidator(),
    ///         authService: InstantService(),
    ///         onSignedIn: { _ in }
    ///     )
    init(
        validator: CredentialValidating = LoginValidator.default,
        authService: Authenticating = StubAuthService(),
        onSignedIn: @escaping (Session) -> Void
    ) {
        self.validator = validator
        self.authService = authService
        self.onSignedIn = onSignedIn
    }

    /// Construye el objeto de valor justo en el momento de usarlo, para que
    /// siempre refleje lo que hay escrito en los campos.
    private var credentials: Credentials {
        Credentials(email: email, password: password)
    }

    // MARK: - Eventos (lo que la vista llama)

    /// Envía el formulario: valida, avisa del fallo o inicia sesión.
    ///
    /// Este método es el flujo completo de la pantalla en 6 líneas, y se lee
    /// como una frase: "si hay un problema, rechaza; si no, entra".
    func submit() async {
        // Guarda contra doble envío: si la persona toca el botón dos veces
        // rápido, el segundo toque no lanza una segunda autenticación.
        guard !isSubmitting else { return }

        if let issue = validator.firstIssue(in: credentials) {
            reject(with: issue)
            return
        }

        await signIn()
    }

    /// Un cambio en los campos retira el error anterior.
    ///
    /// La guarda evita publicar cambios innecesarios: si no había error,
    /// no hay nada que limpiar. Publicar `nil` sobre `nil` haría que SwiftUI
    /// reevaluara la vista sin motivo en cada tecla.
    func clearError() {
        guard errorMessage != nil || invalidField != nil else { return }
        errorMessage = nil
        invalidField = nil
    }

    // MARK: - Detalle interno

    /// Concentra las cuatro consecuencias de un rechazo en un solo lugar:
    /// mensaje, campo marcado, sacudida y foco. Si mañana se añade "retumbar
    /// el borde", se añade aquí y no en cada regla.
    private func reject(with issue: LoginIssue) {
        errorMessage = issue.message
        invalidField = issue.field
        shakeCount += 1
        focusedField = issue.field
    }

    /// Ejecuta la autenticación y traduce el resultado a estado de pantalla.
    ///
    /// Observa la separación `do/catch`: el camino feliz y el camino de error
    /// son explícitos. El `catch` no existía en la versión original, porque
    /// la vista llamaba a `Task.sleep` directamente y no contemplaba fallos.
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

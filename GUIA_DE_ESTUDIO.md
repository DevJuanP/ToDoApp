# Guía de estudio — ToDoApp

Este documento acompaña al código. Sirve para dos cosas: entender **cómo
funciona la pantalla de login** y ver **dónde está cada principio SOLID** en
el proyecto. Lee primero el flujo, después la tabla.

---

## 1. El flujo completo, de un toque a una pantalla nueva

Esta es la secuencia real cuando alguien escribe `alumno@cibertec.edu.pe`,
`123456` y toca "Iniciar sesión". Sigue los números en el código.

```
TOQUE EN EL BOTÓN
        │
        │  PrimaryButton llama a su closure `action`
        ▼
LoginView.submit()                         ← LoginView.swift
        │  la vista NO decide nada, solo lanza una tarea
        │  Task { await viewModel.submit() }
        ▼
LoginViewModel.submit()                    ← LoginViewModel.swift
        │
        ├─ ¿ya está enviando? → return      (guarda contra doble toque)
        │
        ├─ validator.firstIssue(in: credentials)
        │        │
        │        │  recorre las reglas EN ORDEN y para en la primera que falla
        │        ▼
        │   LoginValidator → RequiredEmailRule → EmailFormatRule
        │                  → RequiredPasswordRule → MinimumPasswordLengthRule
        │        │
        │        ├─ HAY PROBLEMA → reject(with: issue)
        │        │        ├─ errorMessage = issue.message
        │        │        ├─ invalidField = issue.field   (borde rojo)
        │        │        ├─ shakeCount += 1             (sacudida + háptico)
        │        │        └─ focusedField = issue.field  (foco al campo malo)
        │        │        └─ FIN
        │        │
        │        └─ TODO BIEN → signIn()
        ▼
LoginViewModel.signIn()
        │  isSubmitting = true  → el botón muestra "Verificando…"
        │
        │  try await authService.signIn(with: credentials)
        ▼
StubAuthService.signIn()                   ← StubAuthService.swift
        │  espera 850 ms (latencia simulada)
        │  devuelve Session(email: ...)
        ▼
LoginViewModel.signIn() (continúa)
        │  successCount += 1
        │  isSubmitting = false
        │  onSignedIn(session)     ← el closure que llegó por el inicializador
        ▼
ContentView (el closure)                   ← ContentView.swift
        │  withAnimation { sessionStore.start(session) }
        ▼
AuthSessionStore.session = Session(...)    ← AuthSessionStore.swift
        │  @Published avisa a quien observa
        ▼
ContentView se redibuja
        │  ahora `if let session` es verdadero
        ▼
HomePlaceholderView aparece con una transición
```

**Lo importante del recorrido:** la vista no aparece ni una sola vez tomando
una decisión. Pregunta, dibuja y reenvía. Cada eslabón se puede sustituir sin
tocar a los demás.

---

## 2. Las tres capas y su regla de dependencia

```
┌──────────────────────────────────────────────┐
│  PRESENTACIÓN                                │
│  LoginView · LoginViewModel · componentes    │
│  Depende de: Dominio + abstracciones         │
└───────────────────┬──────────────────────────┘
                    │  depende hacia abajo
┌───────────────────▼──────────────────────────┐
│  DOMINIO                                     │
│  Credentials · Session · LoginIssue          │
│  ValidationRule · LoginValidator             │
│  No depende de nadie                         │
└───────────────────▲──────────────────────────┘
                    │  implementa sus protocolos
┌───────────────────┴──────────────────────────┐
│  DATOS                                       │
│  Authenticating (protocolo)                  │
│  StubAuthService (implementación)            │
└──────────────────────────────────────────────┘
```

La flecha nunca apunta hacia arriba. El dominio no sabe que existe SwiftUI:
se puede probar sin simulador.

---

## 3. Dónde está cada principio

| Principio | Archivo | Qué mirar |
|---|---|---|
| **S** — Responsabilidad Única | `ContentView.swift` | 573 líneas → una decisión. Compara con tu historial de git |
| | `LoginViewModel.swift` | Toda la lógica del formulario, sin una línea de UI |
| | `CredentialRules.swift` | Cuatro reglas de cuatro tipos; cada una cambia por su propio motivo |
| | `StubAuthService.swift` | Solo convierte credenciales en sesión; no valida ni pinta |
| **O** — Abierto/Cerrado | `ValidationRule.swift` | El protocolo que permite añadir requisitos sin editar lo existente |
| | `LoginValidator.swift` | La lista `rules` es el único punto de extensión |
| **L** — Sustitución de Liskov | `StubAuthService.swift` | Cumple `Authenticating` sin condiciones especiales: cualquier futura implementación real es intercambiable porque el contrato es honesto (`async throws`) |
| **I** — Segregación de Interfaces | `CredentialValidating.swift` | Un método. No se mezcla con autenticación |
| | `Authenticating.swift` | Un método. Quien valida no carga con esto |
| **D** — Inversión de Dependencias | `LoginViewModel.swift` (init) | Recibe `CredentialValidating` y `Authenticating`, nunca las implementaciones |
| **DRY** | `PasswordPolicy.swift` | El `6` en un solo lugar, usado por la regla y por el marcador |
| | `Theme.swift` | Cero colores literales en las vistas |
| | `FieldShell.swift` | La cáscara del campo, escrita una vez |
| **KISS** | `LoginViewModel.submit()` | Seis líneas que se leen como una frase |
| **YAGNI** | `BrandHeader.swift` | Solo los dos casos que existen; no un sistema de temas |
| **Composición sobre herencia** | Todo el proyecto | No hay una sola `class` heredando de otra |
| **Encapsulación** | `AuthSessionStore.swift` | `private(set)`: se lee desde fuera, solo se cambia desde dentro |

---

## 4. Los tres patrones que vale la pena reconocer

### a) Strategy + Composite (validación)

`ValidationRule` es **Strategy**: cada regla es un algoritmo intercambiable.
`LoginValidator` es **Composite**: agrupa estrategias y se comporta como una
sola, porque cumple el mismo tipo de contrato.

Añadir una regla:

```swift
struct DisposableEmailRule: ValidationRule {
    private static let blocked: Set<String> = ["mailinator.com", "tempmail.com"]

    func issue(in credentials: Credentials) -> LoginIssue? {
        let domain = credentials.normalizedEmail.split(separator: "@").last.map(String.init) ?? ""
        guard Self.blocked.contains(domain.lowercased()) else { return nil }
        return LoginIssue(message: "Usa un correo permanente.", field: .email)
    }
}
```

Y una línea en `LoginValidator.default`. **No se toca ninguna regla previa,
ni el view model, ni la vista.**

### b) Dependency Injection por constructor

```swift
init(
    validator: CredentialValidating = LoginValidator.default,
    authService: Authenticating = StubAuthService(),
    onSignedIn: @escaping (Session) -> Void
)
```

Los valores por defecto hacen que la app real no tenga que pasar nada; los
parámetros permiten que un test sustituya cualquiera de los dos. Es la forma
de tener comodidad y testeabilidad sin un contenedor de dependencias.

### c) Observable Object como fuente de verdad

```
AuthSessionStore.session  ──@Published──▶  ContentView redibuja
```

Una sola fuente de verdad para "quién está dentro". No hay copias del estado
en varias vistas, así que no pueden desincronizarse.

---

## 5. Ejercicios sugeridos

En orden de dificultad. Ninguno requiere reescribir nada.

1. **Añadir una regla.** Implementa `NoSpacesEmailRule` (rechaza correos con
   espacios internos). Solo debes tocar dos sitios: el archivo nuevo y la
   lista en `LoginValidator.default`. Si necesitas tocar un tercero, algo del
   diseño está mal — y eso es justamente lo que este proyecto intenta evitar.

2. **Cambiar la política a 8 caracteres.** Edita `PasswordPolicy.minimumLength`.
   Comprueba que el marcador del campo y el mensaje de error cambian solos.

3. **Hacer la credencial real.** Crea `LocalAuthService: Authenticating` que
   acepte solo `alumno@cibertec.edu.pe` / `123456` y lance un error en otro
   caso. Pásalo en `ContentView`:
   ```swift
   LoginView(authService: LocalAuthService()) { session in ... }
   ```
   Ni la vista ni el view model cambian. Ese es el premio de la inversión de
   dependencias.

4. **Escribir el primer test.** `LoginViewModel` se puede probar sin pantalla:
   ```swift
   let vm = LoginViewModel(
       validator: LoginValidator.default,
       authService: StubAuthService(networkDelay: .zero),
       onSignedIn: { _ in }
   )
   vm.email = "sin-arroba"
   await vm.submit()
   XCTAssertEqual(vm.errorMessage, "Ese correo no parece válido.")
   XCTAssertEqual(vm.invalidField, .email)
   ```

5. **Romperlo a propósito.** Borra `import Combine` de `AuthSessionStore.swift`
   y compila. Verás el error de la captura que ya conoces. Entender *por qué*
   pasa (`MEMBER_IMPORT_VISIBILITY`) es más útil que memorizar el arreglo.

---

## 6. Dos advertencias honestas

1. **La validación es local.** `StubAuthService` acepta cualquier credencial
   que pase las reglas. No hay backend, así que no hay autenticación real. El
   pie de la pantalla lo dice de forma explícita para no prometer seguridad
   que no existe.

2. **Esto es más estructura de la que un login necesita** en un proyecto de
   un solo archivo. Es deliberado: el objetivo era practicar SOLID, no
   optimizar para este caso concreto. En una app real de este tamaño, la mitad
   de estos archivos sobraría. Saber cuándo aplicar el patrón y cuándo no
   forma parte del oficio.

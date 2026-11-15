//
//  LoginLayout.swift
//  ToDoApp
//
//  CAPA: Presentación
//

import SwiftUI

/// Ritmo vertical y medidas del formulario de acceso, en un solo lugar.
///
/// ¿Por qué constantes en vez de números sueltos en la vista?
///
/// Por dos motivos prácticos:
///
/// 1. **Ajustar el ritmo es una sola operación.** El espaciado de un
///    formulario se pule mirándolo, no calculándolo. Con los valores
///    centralizados se cambia un número y se ve el efecto en toda la
///    pantalla, sin recorrer ocho llamadas a `.padding`.
///
/// 2. **Los números ganan significado.** `.padding(.top, 40)` no dice nada;
///    `LoginLayout.headerTopPadding` dice "el aire entre la marca y el
///    titular". La constante documenta la intención.
///
/// Es un `enum` sin casos: no se instancia, solo agrupa. Si estos valores
/// se compartieran entre pantallas convendría mudarlos a `DesignSystem`,
/// pero por ahora solo los usa esta vista y no hay que adelantarse
/// (YAGNI).
enum LoginLayout {
    /// Ancho máximo del formulario. En iPad evita líneas interminables;
    /// en iPhone nunca se alcanza.
    static let contentMaxWidth: CGFloat = 460

    static let horizontalPadding: CGFloat = 28

    // El ritmo vertical, de arriba abajo. Los valores crecen con la
    // importancia del bloque: más aire antes del titular que entre campos.
    static let brandTopPadding: CGFloat = 18
    static let headerTopPadding: CGFloat = 40
    static let fieldsTopPadding: CGFloat = 34
    static let actionTopPadding: CGFloat = 30
    static let footerTopPadding: CGFloat = 26
    static let bottomPadding: CGFloat = 32

    /// Cuánto sube el contenido durante la animación de entrada.
    static let appearOffset: CGFloat = 14
}

//
//  PasswordPolicy.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Política de contraseñas: el mínimo vive en un solo lugar.
///
/// Este es el ejemplo más pequeño de DRY del proyecto. El número 6 se usa en
/// dos sitios con significados distintos:
///
///   - la regla que rechaza contraseñas cortas (`MinimumPasswordLengthRule`)
///   - el texto de ayuda "Mínimo 6 caracteres" que ve la persona
///
/// Si estuviera escrito dos veces, cambiar la política a 8 obligaría a buscar
/// el número por todo el proyecto y confiar en no dejar ninguna copia atrás.
/// Con la constante, se cambia una línea y la interfaz y la validación siguen
/// de acuerdo por construcción.
///
/// Es un `enum` sin casos a propósito: no se puede instanciar, así que solo
/// sirve como espacio de nombres. En Swift es la forma idiomática de agrupar
/// constantes sin contaminar el ámbito global.
enum PasswordPolicy {
    static let minimumLength = 6
}

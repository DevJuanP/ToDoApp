//
//  ValidationRule.swift
//  ToDoApp
//

/// Una sola regla del formulario.
///
/// Abierto/cerrado: para exigir algo nuevo se agrega un tipo nuevo
/// a la lista; no se edita la validación existente.
protocol ValidationRule {
    /// Devuelve el problema que esta regla detecta, o `nil` si se cumple.
    func issue(in credentials: Credentials) -> LoginIssue?
}

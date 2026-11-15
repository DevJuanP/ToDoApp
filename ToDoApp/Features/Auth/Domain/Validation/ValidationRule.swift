//
//  ValidationRule.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Una sola regla del formulario.
///
/// Este protocolo es el que hace posible el principio **Open/Closed**.
///
/// El problema que resuelve: si la validación fuera una función con
/// `if` encadenados, cada requisito nuevo obliga a abrir esa función,
/// entenderla entera y modificarla. Es decir: el código *cerrado a cambios*
/// no lo estaría, y cualquier edición arriesga romper una regla que ya
/// funcionaba.
///
/// Con este protocolo, cada regla es un tipo independiente y el sistema
/// queda **abierto a extensión** (agregar tipos) y **cerrado a modificación**
/// (no se toca lo existente).
///
/// Contrato intencional: devuelve `nil` si la regla se cumple, o el problema
/// si no. Es el patrón "command + query": no muta nada, solo responde.
protocol ValidationRule {
    /// Devuelve el problema que esta regla detecta, o `nil` si se cumple.
    func issue(in credentials: Credentials) -> LoginIssue?
}

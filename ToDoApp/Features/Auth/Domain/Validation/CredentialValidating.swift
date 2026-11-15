//
//  CredentialValidating.swift
//  ToDoApp
//
//  CAPA: Dominio
//

/// Contrato de validación que consume la pantalla.
///
/// Este es el punto donde entra el principio de **Inversión de Dependencias**.
///
/// La regla dice que un módulo de alto nivel no debe depender de uno de bajo
/// nivel, sino que ambos deben depender de abstracciones. Aquí:
///
///   - alto nivel  → `LoginViewModel` (decide qué hacer)
///   - bajo nivel  → las reglas concretas (`EmailFormatRule`, etc.)
///   - abstracción → este protocolo
///
/// `LoginViewModel` nunca menciona `EmailFormatRule`. Solo pide "algo que
/// sepa validar credenciales". Eso permite dos cosas que sin el protocolo
/// serían imposibles:
///
///   1. En tests, inyectar un validador falso que siempre falla (o siempre
///      pasa) para probar la reacción de la pantalla sin depender de regex.
///   2. En la app real, cambiar la configuración de reglas sin tocar la vista.
///
/// Nota de **Segregación de Interfaces**: este protocolo tiene un solo
/// método. No se mezcla con autenticación ni con presentación, porque quien
/// valida no necesita saber nada de sesiones ni de colores.
protocol CredentialValidating {
    /// El primer problema encontrado, en el orden en que se revisan las reglas.
    func firstIssue(in credentials: Credentials) -> LoginIssue?
}

//
//  ContentView.swift
//  ToDoApp
//
//  Created by XCODE on 12/11/26.
//

import SwiftUI
import UIKit

// MARK: - Theme

private enum Theme {
    static let paper = Color.dynamic(light: 0xFAF7F2, dark: 0x121311)
    static let field = Color.dynamic(light: 0xFFFFFF, dark: 0x1C1E1B)
    static let ink = Color.dynamic(light: 0x1A1A1D, dark: 0xF3F0EA)
    static let inkRaised = Color.dynamic(light: 0x2B2B30, dark: 0xFFFFFF)
    static let inkSoft = Color.dynamic(light: 0x5F5F67, dark: 0xA9A69E)
    static let hairline = Color.dynamic(light: 0xE0DAD0, dark: 0x34362F)
    static let pine = Color.dynamic(light: 0x2E5B4A, dark: 0x74C0A2)
    static let pineDeep = Color.dynamic(light: 0x1F4436, dark: 0x4E9A80)
    static let danger = Color.dynamic(light: 0x9E3223, dark: 0xEC9382)
    static let onInk = Color.dynamic(light: 0xFAF7F2, dark: 0x11120F)
    static let onPine = Color.dynamic(light: 0xFCFAF5, dark: 0x0E1F18)
}

private extension Color {
    static func dynamic(light: UInt32, dark: UInt32) -> Color {
        Color(uiColor: UIColor(dynamicProvider: { traits in
            UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
        }))
    }
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}

// MARK: - ContentView

struct ContentView: View {
    @State private var signedInEmail: String?

    var body: some View {
        ZStack {
            LoginBackdrop()

            if let signedInEmail {
                SignedInView(email: signedInEmail) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) {
                        self.signedInEmail = nil
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 0.98)))
            } else {
                LoginView { email in
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.88)) {
                        signedInEmail = email
                    }
                }
                .transition(.opacity.combined(with: .scale(scale: 1.02)))
            }
        }
        .tint(Theme.pine)
    }
}

// MARK: - Backdrop

private struct LoginBackdrop: View {
    var body: some View {
        ZStack {
            Theme.paper

            RadialGradient(
                colors: [Theme.pine.opacity(0.11), Theme.pine.opacity(0)],
                center: UnitPoint(x: 0.92, y: -0.06),
                startRadius: 12,
                endRadius: 470
            )

            RadialGradient(
                colors: [Theme.ink.opacity(0.05), Theme.ink.opacity(0)],
                center: UnitPoint(x: 0.02, y: 1.04),
                startRadius: 8,
                endRadius: 420
            )
        }
        .ignoresSafeArea()
    }
}

// MARK: - Login

private struct LoginView: View {
    var onSignIn: (String) -> Void

    private enum Field: Hashable {
        case email
        case password
    }

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage: String?
    @State private var invalidField: Field?
    @State private var isSubmitting = false
    @State private var shakeCount = 0
    @State private var successCount = 0
    @State private var hasAppeared = false
    @FocusState private var focusedField: Field?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                brandRow
                    .padding(.top, 18)

                headline
                    .padding(.top, 40)

                fields
                    .padding(.top, 34)

                signInButton
                    .padding(.top, 30)

                Text("Vista de ejemplo: aún no hay servidor conectado.")
                    .font(.footnote)
                    .foregroundStyle(Theme.inkSoft)
                    .padding(.top, 26)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 32)
            .frame(maxWidth: 460)
            .frame(maxWidth: .infinity, minHeight: 0)
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared || reduceMotion ? 0 : 14)
            .animation(reduceMotion ? nil : .easeOut(duration: 0.6), value: hasAppeared)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .sensoryFeedback(.error, trigger: shakeCount)
        .sensoryFeedback(.success, trigger: successCount)
        .onAppear { hasAppeared = true }
        .onChange(of: email) { _, _ in clearError() }
        .onChange(of: password) { _, _ in clearError() }
        .animation(.easeOut(duration: 0.22), value: errorMessage)
    }

    private func clearError() {
        guard errorMessage != nil || invalidField != nil else { return }
        withAnimation(.easeOut(duration: 0.18)) {
            errorMessage = nil
            invalidField = nil
        }
    }

    // MARK: Brand

    private var brandRow: some View {
        HStack(spacing: 12) {
            BrandMark(size: 40)

            Text("ToDoApp")
                .font(.system(size: 15, weight: .semibold))
                .kerning(0.5)
                .foregroundStyle(Theme.inkSoft)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("ToDoApp")
    }

    // MARK: Headline

    private var headline: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hola de nuevo")
                .font(.system(.largeTitle, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityAddTraits(.isHeader)

            Text("Entra para retomar los pendientes de hoy.")
                .font(.callout)
                .foregroundStyle(Theme.inkSoft)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: Fields

    private var fields: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 18) {
                FieldShell(label: "Correo", isFocused: focusedField == .email, isInvalid: invalidField == .email) {
                    HStack(spacing: 11) {
                        Image(systemName: "envelope")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.inkSoft)
                            .frame(width: 20)

                        ZStack(alignment: .leading) {
                            if email.isEmpty {
                                Text("tu@correo.com")
                                    .foregroundStyle(Theme.inkSoft)
                                    .allowsHitTesting(false)
                                    .accessibilityHidden(true)
                            }

                            TextField("", text: $email)
                                .focused($focusedField, equals: .email)
                                .keyboardType(.emailAddress)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .onSubmit { focusedField = .password }
                                .foregroundStyle(Theme.ink)
                                .accessibilityLabel("Correo electrónico")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 17))
                    }
                }

                FieldShell(label: "Contraseña", isFocused: focusedField == .password, isInvalid: invalidField == .password) {
                    HStack(spacing: 11) {
                        Image(systemName: "lock")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.inkSoft)
                            .frame(width: 20)

                        ZStack(alignment: .leading) {
                            if password.isEmpty {
                                Text("Mínimo 6 caracteres")
                                    .foregroundStyle(Theme.inkSoft)
                                    .allowsHitTesting(false)
                                    .accessibilityHidden(true)
                            }

                            passwordInput
                                .focused($focusedField, equals: .password)
                                .textContentType(.password)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.go)
                                .onSubmit(submit)
                                .foregroundStyle(Theme.ink)
                                .accessibilityLabel("Contraseña")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 17))

                        Button {
                            let wasFocused = focusedField == .password
                            isPasswordVisible.toggle()

                            if wasFocused {
                                // Swapping SecureField for TextField rebuilds the responder chain.
                                Task { @MainActor in
                                    try? await Task.sleep(for: .milliseconds(40))
                                    focusedField = .password
                                }
                            }
                        } label: {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .font(.system(size: 15))
                                .foregroundStyle(Theme.inkSoft)
                                .frame(width: 30, height: 30)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel(isPasswordVisible ? "Ocultar contraseña" : "Mostrar contraseña")
                    }
                }
            }
            .modifier(ShakeEffect(animatableData: CGFloat(shakeCount)))
            .animation(.linear(duration: 0.45), value: shakeCount)

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.circle.fill")
                    .font(.footnote)
                    .foregroundStyle(Theme.danger)
                    .fixedSize(horizontal: false, vertical: true)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    @ViewBuilder
    private var passwordInput: some View {
        if isPasswordVisible {
            TextField("", text: $password)
        } else {
            SecureField("", text: $password)
        }
    }

    // MARK: Call to action

    private var signInButton: some View {
        Button(action: submit) {
            HStack(spacing: 10) {
                if isSubmitting {
                    ProgressView()
                        .controlSize(.small)
                        .tint(Theme.onInk)

                    Text("Verificando…")
                } else {
                    Text("Iniciar sesión")

                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Theme.onInk)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Theme.inkRaised, Theme.ink],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .opacity(isSubmitting ? 0.9 : 1)
        }
        .buttonStyle(PressStyle())
        .disabled(isSubmitting)
        .accessibilityLabel("Iniciar sesión")
    }

    // MARK: Actions

    private func submit() {
        guard !isSubmitting else { return }

        if case let (issue, field)? = validationIssue() {
            withAnimation(.easeOut(duration: 0.22)) {
                errorMessage = issue
                invalidField = field
            }
            shakeCount += 1
            focusedField = field
            return
        }

        withAnimation(.easeOut(duration: 0.22)) {
            errorMessage = nil
            invalidField = nil
        }
        focusedField = nil
        isSubmitting = true
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(850))
            successCount += 1
            isSubmitting = false
            onSignIn(trimmedEmail)
        }
    }

    private func validationIssue() -> (String, Field)? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            return ("Escribe tu correo para continuar.", .email)
        }

        let pattern = #"^[^@\s]+@[^@\s]+\.[A-Za-z]{2,}$"#
        if trimmedEmail.range(of: pattern, options: .regularExpression) == nil {
            return ("Ese correo no parece válido.", .email)
        }

        if password.isEmpty {
            return ("Escribe tu contraseña.", .password)
        }

        if password.count < 6 {
            return ("La contraseña necesita al menos 6 caracteres.", .password)
        }

        return nil
    }
}

// MARK: - Field shell

private struct FieldShell<Content: View>: View {
    private let label: String
    private let isFocused: Bool
    private let isInvalid: Bool
    private let content: Content

    init(label: String, isFocused: Bool, isInvalid: Bool, @ViewBuilder content: () -> Content) {
        self.label = label
        self.isFocused = isFocused
        self.isInvalid = isInvalid
        self.content = content()
    }

    private var borderColor: Color {
        if isInvalid { return Theme.danger }
        return isFocused ? Theme.pine : Theme.hairline
    }

    private var borderWidth: CGFloat {
        isInvalid || isFocused ? 1.6 : 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(label)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(isInvalid ? Theme.danger : Theme.inkSoft)

            content
                .padding(.horizontal, 16)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Theme.field)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(borderColor, lineWidth: borderWidth)
                )
                .animation(.easeOut(duration: 0.18), value: isFocused)
                .animation(.easeOut(duration: 0.18), value: isInvalid)
        }
    }
}

// MARK: - Brand mark

private struct BrandMark: View {
    var size: CGFloat = 40

    private let check = CheckGlyph()

    var body: some View {
        RoundedRectangle(cornerRadius: size * 0.3, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [Theme.pine, Theme.pineDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay(
                check
                    .stroke(
                        Theme.onPine,
                        style: StrokeStyle(lineWidth: size * 0.105, lineCap: .round, lineJoin: .round)
                    )
                    .padding(size * 0.27)
            )
            .accessibilityHidden(true)
    }
}

private struct CheckGlyph: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.06, y: rect.minY + rect.height * 0.54))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.38, y: rect.minY + rect.height * 0.84))
        path.addLine(to: CGPoint(x: rect.minX + rect.width * 0.96, y: rect.minY + rect.height * 0.16))
        return path
    }
}

// MARK: - Motion

private struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(
            CGAffineTransform(translationX: 9 * sin(animatableData * .pi * 3), y: 0)
        )
    }
}

private struct PressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

// MARK: - Signed in (placeholder for the real home)

private struct SignedInView: View {
    let email: String
    let onSignOut: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            BrandMark(size: 56)

            Text("Sesión iniciada")
                .font(.system(.title, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                .padding(.top, 24)
                .accessibilityAddTraits(.isHeader)

            Text(email)
                .font(.subheadline)
                .foregroundStyle(Theme.inkSoft)
                .lineLimit(1)
                .truncationMode(.middle)
                .padding(.top, 8)
                .padding(.horizontal, 36)

            Text("Aquí empezará tu lista de pendientes.")
                .font(.footnote)
                .foregroundStyle(Theme.inkSoft)
                .padding(.top, 6)

            Spacer()

            Button(action: onSignOut) {
                Text("Cerrar sesión")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.ink)
                    .frame(maxWidth: .infinity, minHeight: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Theme.hairline, lineWidth: 1)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .buttonStyle(PressStyle())
            .padding(.horizontal, 28)
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}

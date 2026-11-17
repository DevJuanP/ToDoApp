# Preview en la nube

El proyecto es SwiftUI, así que no se puede ejecutar en Windows. Este workflow
resuelve eso: un Mac de GitHub compila la app con Xcode de verdad, la corre en
el simulador de iOS y sube capturas como artifact.

## Uso

1. Sube los cambios a `main` (o lanza el workflow a mano desde **Actions**).
2. Espera ~4–6 min.
3. Abre la ejecución → **Artifacts** → descarga `preview-capturas`.

Contiene:

| Archivo | Para qué |
|---|---|
| `login-claro.png` | Captura real, apariencia clara |
| `login-oscuro.png` | Captura real, apariencia oscura |
| `ToDoApp.app.zip` | Súbelo a [appetize.io](https://appetize.io) para tener el simulador **interactivo** en el navegador |

## Por qué el runner es `macos-26`

`project.pbxproj` declara `IPHONEOS_DEPLOYMENT_TARGET = 26.2`. Eso exige Xcode
26.2 o superior. Los runners `macos-14` y `macos-15` no lo traen (y `macos-14`
fue retirado el 2 de noviembre de 2026). `macos-26` sí incluye Xcode 26.2–26.6
y el simulador de iOS 26.2.

## Dos detalles que rompen este tipo de workflow y aquí están resueltos

**Scheme compartido.** Sin `ToDoApp.xcodeproj/xcshareddata/xcschemes/ToDoApp.xcscheme`,
`xcodebuild -scheme ToDoApp` falla en CI porque los schemes que crea Xcode al
abrir el proyecto son *de usuario* (`xcuserdata`, ignorado por git). El scheme
compartido está versionado en el repo justamente por esto.

**Firma de código.** El paso de compilación pasa `CODE_SIGNING_ALLOWED=NO`. El
simulador no exige firma, así que no hace falta configurar certificados ni
credenciales de Apple en el repo.

## Qué no hace

- No verifica la lógica: no hay tests. Su valor es visual + comprobar que el
  código compila con un Xcode real.
- No sustituye a probar en un iPhone físico (haptics, teclado real, Dynamic
  Type, VoiceOver).
- Las capturas son de la pantalla de login únicamente. Cuando exista otra
  pantalla habrá que añadir pasos para navegar hasta ella.

## Alternativa interactiva sin escribir nada

[Axint Cloud Preview](https://axint.ai/cloud/preview) hace lo mismo pero
streameando el simulador al navegador (plan gratis: 60 min, repos públicos).
Este workflow sigue siendo útil porque es reproducible y queda versionado.

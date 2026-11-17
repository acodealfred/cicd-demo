# cicd-demo

A minimal SwiftUI app used to exercise CI/CD. Simulator-only for now: no code signing or deployment.

## Structure

| Path | Purpose |
|---|---|
| `cicd-demo.xcodeproj/project.xcproj` | Project file (new Xcode 27 text format; edit via Xcode or `xcrun xcodeproj`, not by hand) |
| `cicd-demo.xcodeproj/xcshareddata/xcschemes/cicd-demo.xcscheme` | Shared scheme used by CI (builds app, runs `cicd-demoTests`) |
| `cicd-demo/` | App target `cicd-demo` (module `cicd_demo`) |
| `cicd-demo/MyApp.swift` | `@main` app entry |
| `cicd-demo/ContentView.swift` | Root view |
| `cicd-demo/Greeting.swift` | Pure greeting logic (unit tested) |
| `cicd-demoTests/` | Unit test target `cicd-demoTests` (Swift Testing, hosted in the app) |
| `.github/workflows/ci.yml` | GitHub Actions: build + test on every push / PR |

Folders are synchronized: files added under `cicd-demo/` or `cicd-demoTests/` join that target automatically.

## Toolchain

- Xcode 27.2 or newer (local dev uses Xcode 27.3 beta).
- iOS deployment target: **27.2**. Keep it ≤ the newest iOS SDK on the CI image.
- App target uses `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`; mark pure logic `nonisolated` so tests don't need the main actor.

## Commands

List targets and schemes:

```sh
xcodebuild -list -project cicd-demo.xcodeproj
```

Build for the simulator:

```sh
xcodebuild build -project cicd-demo.xcodeproj -scheme cicd-demo \
  -destination 'platform=iOS Simulator,name=iPhone 17' CODE_SIGNING_ALLOWED=NO
```

Run unit tests:

```sh
xcodebuild test -project cicd-demo.xcodeproj -scheme cicd-demo \
  -destination 'platform=iOS Simulator,name=iPhone 17' CODE_SIGNING_ALLOWED=NO
```

## Conventions

- Unit tests use Swift Testing (`import Testing`, `@Test`, `#expect`), with `@testable import cicd_demo`.
- Put testable logic in plain types outside views.
- CI runs on the GitHub `xcode-27` image (Preview) with Xcode 27.2 pinned via `DEVELOPER_DIR`. When bumping the deployment target, check that image's README for the available SDKs first.
- Project file changes: use Xcode or `xcrun xcodeproj` (e.g. `xcrun xcodeproj target add-dependency`).

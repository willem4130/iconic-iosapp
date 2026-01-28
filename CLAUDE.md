# Iconic Festival iOS App

Official mobile app for Iconic Festival 2026 - a tribute festival at Goffertpark, Nijmegen.

**Stack:** SwiftUI + Swift 5.9 + iOS 17+ + SwiftData + XcodeGen

## Project Structure

```
IconicFestival/
├── App/                    # App entry, RootView, AppDelegate
├── Core/
│   ├── Navigation/         # Router, Routes
│   ├── Theme/              # AppColors (brand colors)
│   ├── Network/            # NetworkClient, Endpoint
│   ├── Storage/            # Keychain, UserDefaults
│   ├── Components/         # Reusable UI components
│   └── Extensions/         # Swift extensions
├── Features/
│   ├── Timetable/          # Festival schedule view
│   ├── Info/               # FAQ, venue, contact
│   ├── Chat/               # AI assistant
│   └── Settings/           # App settings
├── Models/                 # Data models (TimetableData, FestivalInfo)
└── Services/               # Business logic
```

## Code Quality - Run After Every Edit

```bash
# Build check (in Xcode: Cmd+B)
xcodebuild -project IconicFestival.xcodeproj -scheme IconicFestival build CODE_SIGNING_ALLOWED=NO 2>&1 | grep -E "error:|warning:"

# Or use SwiftLint if installed
swiftlint lint IconicFestival/
```

Fix ALL errors before continuing.

## Organization Rules

- **Views** → `Features/[Feature]/View/`
- **ViewModels** → `Features/[Feature]/ViewModel/`
- **Models** → `Models/`
- **Shared components** → `Core/Components/`
- **Navigation** → `Core/Navigation/Route.swift` + `Router.swift`
- **One responsibility per file**

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Dark | #08192C | Nav bars, backgrounds |
| Primary Gold | #F29100 | Accent, buttons |
| Main Stage | #AA7712 | Stage indicator |
| Theater | #E8927C | Stage indicator |

## Timetable (Scenario #177)

**Main Stage:** Beach Boys' Best (14:00) → Coming on Strong → Cosmic Carnival → Treasure → Donna's Hot Stuff → Dirty Daddies (22:15, Headliner)

**Openluchttheater:** ABBA GOLD (15:00) → Urban Solitude → Future Nostalgia → The Dutch Queen (21:00, Headliner)

## Commands

```bash
xcodegen generate              # Regenerate Xcode project
open IconicFestival.xcodeproj  # Open in Xcode
xcodebuild test                # Run tests
```

## Adding Features

1. Create view in `Features/[Feature]/View/`
2. Add ViewModel if needed in `Features/[Feature]/ViewModel/`
3. Add route to `Core/Navigation/Route.swift`
4. Update `Router.destination(for:)`

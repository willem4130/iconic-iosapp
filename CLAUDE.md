# Iconic Festival iOS App

Official mobile app for Iconic Festival 2026 - a tribute band festival at Goffertpark, Nijmegen. Features timetable, venue info, AI chat assistant (Claude), and push notifications.

**Stack:** SwiftUI + Swift 5.9 + iOS 17+ + SwiftData + Claude API + XcodeGen

## Quick Start

```bash
# Project location
cd /Users/willemvandenberg/Dev/Iconic/iconic-iosapp

# Open in Xcode
open IconicFestival.xcodeproj

# Build from CLI
xcodebuild -scheme IconicFestival -destination 'platform=iOS Simulator,name=iPhone 17' build

# Run in simulator
xcodebuild -scheme IconicFestival -destination 'platform=iOS Simulator,name=iPhone 17' build && xcrun simctl boot "iPhone 17" 2>/dev/null; xcrun simctl install "iPhone 17" ~/Library/Developer/Xcode/DerivedData/IconicFestival-*/Build/Products/Debug-iphonesimulator/IconicFestival.app && xcrun simctl launch "iPhone 17" com.iconicfestival.app
```

**Remote:** https://github.com/willem4130/iconic-iosapp.git
**Branch:** `feature/setup-commands`

## Project Structure

```
IconicFestival/
├── App/                    # App entry, RootView, AppDelegate
├── Core/
│   ├── Navigation/         # Router, Routes, NavigationModifiers
│   ├── Theme/              # AppColors, ThemeManager
│   ├── Network/            # NetworkClient, Endpoint, NetworkMonitor
│   ├── Storage/            # KeychainManager, UserDefaultsManager
│   ├── Components/         # Reusable UI (Buttons, LoadingView, etc.)
│   ├── Extensions/         # Swift extensions
│   ├── DependencyInjection/# DI container
│   ├── Logger/             # Logging system
│   └── Utilities/          # FormValidation, HapticFeedback
├── Features/
│   ├── Timetable/          # Festival schedule (View + ViewModel)
│   ├── Info/               # FAQ, venue, contact info
│   ├── Chat/               # AI assistant (View + ViewModel)
│   └── Settings/           # Settings, Profile, AISettings, About
├── Models/                 # TimetableData, FestivalInfo, KnowledgeBase, SwiftData
├── Services/               # ClaudeService, AuthService, NotificationService
├── Configuration/          # Debug/Staging/Production/Secrets xcconfig
└── Resources/              # Assets.xcassets, Knowledge_Base.json
```

## Code Quality - Run After Every Edit

```bash
# Build check (catches most issues)
xcodebuild -scheme IconicFestival -destination 'platform=iOS Simulator,name=iPhone 17' -quiet build 2>&1 | grep -E "error:|warning:"

# Or in Xcode: Cmd+B
```

Fix ALL errors before continuing.

## Organization Rules

- **Views** → `Features/[Feature]/View/`
- **ViewModels** → `Features/[Feature]/ViewModel/`
- **Models** → `Models/`
- **Services** → `Services/` (ClaudeService, AuthService, etc.)
- **Shared components** → `Core/Components/`
- **Navigation** → `Core/Navigation/Route.swift` + `Router.swift`
- **One responsibility per file**

## Key Files

| File | Purpose |
|------|---------|
| `Models/TimetableData.swift` | All artists, performances, socials, image URLs |
| `Models/FestivalInfo.swift` | Contact info, FAQ, venue details |
| `Services/ClaudeService.swift` | Claude API integration, conversation history |
| `Features/Chat/ViewModel/ChatViewModel.swift` | Chat logic + offline fallback |
| `Core/Components/CachedAsyncImage.swift` | Image loading with NSCache |
| `Configuration/Secrets.xcconfig` | API keys (gitignored) |
| `ARTISTS.md` | Documentation of all band social links |

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary Dark | #08192C | Nav bars, backgrounds |
| Primary Gold | #F29100 | Accent, buttons |
| Main Stage | #AA7712 | Stage indicator |
| Theater | #E8927C | Stage indicator |

## Commands

```bash
xcodegen generate              # Regenerate project from project.yml
open IconicFestival.xcodeproj  # Open in Xcode
xcodebuild test -scheme IconicFestival -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Adding Features

1. Create view in `Features/[Feature]/View/`
2. Add ViewModel if needed in `Features/[Feature]/ViewModel/`
3. Add route case to `Core/Navigation/Route.swift`
4. Handle route in `Router.destination(for:)` in `Router.swift`

## Timetable 2026

**Main Stage:** Beach Boys' Best (14:00) → Coming on Strong → Cosmic Carnival → Treasure → Donna's Hot Stuff → Dirty Daddies (22:15, Headliner)

**Openluchttheater:** ABBA GOLD (15:00) → Urban Solitude → Future Nostalgia → The Dutch Queen (21:00, Headliner)

## Artist Images

All artist photos are loaded from `iconicfestival.nl` via the `imageURL` field on each `Artist` in `TimetableData.swift`. Images are displayed using `CachedAsyncImage` (in `Core/Components/CachedAsyncImage.swift`) which provides in-memory caching via `NSCache` (100 items / 50MB limit).

## Festival Social Media

- **Website:** https://www.iconicfestival.nl
- **Instagram:** https://www.instagram.com/iconic_festival/
- **Facebook:** https://www.facebook.com/iconictribute/
- **Linktree:** https://linktr.ee/iconic_festival

Contact URLs are defined in `FestivalInfo.swift` → `ContactInfo` struct.

Social links appear in:
- `TimetableView` header (icons below date)
- `ChatView` welcome message
- `SettingsView` "Volg Ons" section
- `InfoView` contact section
- `AboutView` links section

## Artist Social Links

All 10 artists have validated social links (website, Instagram, Facebook, YouTube) stored in `TimetableData.swift` via `ArtistSocials`. See `ARTISTS.md` for the complete reference.

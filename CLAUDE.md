# Iconic Festival iOS App

Official mobile app for Iconic Festival 2026 - a tribute festival at Goffertpark, Nijmegen.

## Tech Stack

- **SwiftUI** - Modern declarative UI framework
- **Swift 5.9** - Latest Swift with strict concurrency
- **iOS 17+** - Minimum deployment target
- **SwiftData** - Local persistence for favorites and chat
- **XcodeGen** - Project generation from YAML

## Project Structure

```
IconicFestival/
├── App/
│   ├── IconicFestivalApp.swift    # Main app entry point
│   ├── RootView.swift              # Tab-based navigation
│   ├── AppDelegate.swift           # Push notifications
│   └── AppEnvironment.swift        # Environment config
│
├── Core/
│   ├── Navigation/                 # Router, Routes
│   ├── Theme/                      # AppColors (brand colors)
│   ├── Network/                    # NetworkClient, Endpoint
│   ├── Storage/                    # Keychain, UserDefaults
│   ├── Components/                 # Reusable UI components
│   ├── Extensions/                 # Swift extensions
│   └── Utilities/                  # Helpers
│
├── Features/
│   ├── Timetable/                  # Festival schedule
│   │   └── View/TimetableView.swift
│   ├── Info/                       # FAQ, venue, contact
│   │   └── View/InfoView.swift
│   ├── Chat/                       # AI assistant
│   │   ├── View/ChatView.swift
│   │   └── ViewModel/ChatViewModel.swift
│   └── Settings/                   # App settings
│       └── View/SettingsView.swift
│
├── Models/
│   ├── TimetableData.swift         # Festival schedule data
│   ├── FestivalInfo.swift          # FAQ and venue info
│   └── SwiftDataModels.swift       # Persistence models
│
└── Services/
    └── AuthService.swift           # (Future: auth)
```

## Brand Colors

| Color | Hex | Usage |
|-------|-----|-------|
| Primary White | #FFFFFF | Text on dark backgrounds |
| Primary Dark | #08192C | Navigation bars, backgrounds |
| Primary Gold | #F29100 | Accent, buttons, highlights |
| Main Stage | #AA7712 | Main Stage indicator |
| Theater Stage | #E8927C | Theater Stage indicator |

## Timetable Data

Using **Scenario #177** (recommended):
- Maximum overlap between stages
- Both Urban Solitude and Future Nostalgia get full 75-min sets
- 30-min gap for food/toilet break

### Main Stage
1. Beach Boys' Best: 14:00-15:00
2. Coming on Strong: 15:15-16:15
3. The Cosmic Carnival: 16:45-17:45
4. Treasure: 18:30-19:45
5. Donna's Hot Stuff: 20:15-21:30
6. Dirty Daddies (Headliner): 22:15-23:30

### Openluchttheater
1. ABBA GOLD Europe: 15:00-16:15
2. Urban Solitude: 17:00-18:15
3. Future Nostalgia: 19:00-20:15
4. The Dutch Queen (Headliner): 21:00-22:30

## Quick Start

```bash
# Generate Xcode project (requires XcodeGen)
brew install xcodegen
cd iconic-iosapp
xcodegen generate

# Open in Xcode
open IconicFestival.xcodeproj
```

## Commands

```bash
xcodegen generate         # Regenerate Xcode project
xcodebuild build          # Build project
xcodebuild test           # Run tests
```

## Adding Features

### New View
1. Create view in `Features/[Feature]/View/`
2. Create ViewModel in `Features/[Feature]/ViewModel/` (if needed)
3. Add route to `Core/Navigation/Route.swift`
4. Update `Router.destination(for:)` in `Core/Navigation/Router.swift`

### New Data Model
1. Add to `Models/` directory
2. If using SwiftData, add to schema in `IconicFestivalApp.swift`

## AI Chat

The chat assistant uses local pattern matching for demo purposes.

To integrate real Claude API:
1. Add `ANTHROPIC_API_KEY` to environment
2. Update `ChatViewModel.getResponse()` to call Claude API
3. Pass `festivalContext` as system prompt

## Related Projects

- `/Users/willemvandenberg/Dev/Iconic/Timetable2026` - Timetable generator
- `/Users/willemvandenberg/Dev/Iconic/Weeztix` - Festival analytics platform
- `/Users/willemvandenberg/Dev/SSO/Pareto` - AI/Tambo patterns reference

## Future Enhancements

- [ ] Real Claude API integration for chat
- [ ] Push notifications for performance reminders
- [ ] Favorite artists with notifications
- [ ] Festival map integration
- [ ] Offline mode for timetable
- [ ] Ticket integration with Weeztix

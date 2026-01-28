# Iconic Festival App

**The official mobile app for Iconic Festival 2026**

A tribute festival experience at Goffertpark, Nijmegen featuring amazing tribute bands on two stages.

---

## Features

- **Timetable** - Full festival schedule with both stages
- **Info & FAQ** - Venue info, practical tips, and frequently asked questions
- **AI Assistant** - Ask anything about the festival
- **Notifications** - Never miss your favorite acts
- **Dark Mode** - Full dark/light theme support

---

## Screenshots

The app features a clean, modern design with the Iconic Festival brand colors:
- Dark Blue (#08192C) - Navigation and backgrounds
- Gold (#F29100) - Accent and highlights
- Stage-specific colors for easy identification

---

## Tech Stack

- **SwiftUI** - Modern iOS UI framework
- **iOS 17+** - Latest iOS features
- **SwiftData** - Local persistence
- **Swift 5.9** - Latest Swift language

---

## Get Started

### Prerequisites

- Mac with **Xcode 15+** installed
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for project generation

### Installation

```bash
# Clone the repository
git clone https://github.com/willem4130/iconic-iosapp.git
cd iconic-iosapp

# Install XcodeGen (if not already installed)
brew install xcodegen

# Generate Xcode project
xcodegen generate

# Open in Xcode
open IconicFestival.xcodeproj
```

### Run the App

1. Open `IconicFestival.xcodeproj` in Xcode
2. Select a simulator (iPhone 16 recommended)
3. Press `Cmd + R` to build and run

---

## Festival Info

**Iconic Festival 2026**
- **Location**: Goffertpark, Nijmegen
- **Stages**: Main Stage (5000 cap) + Openluchttheater (2000 cap)
- **Opening**: 13:00 (first act at 14:00)

### Lineup

**Main Stage**
- Beach Boys' Best
- Coming on Strong
- The Cosmic Carnival
- Treasure (Bruno Mars tribute)
- Donna's Hot Stuff (Donna Summer tribute)
- Dirty Daddies (Headliner)

**Openluchttheater**
- ABBA GOLD Europe
- Urban Solitude (Anouk tribute)
- Future Nostalgia (Dua Lipa tribute)
- The Dutch Queen (Queen tribute - Headliner)

---

## Project Structure

```
IconicFestival/
├── App/            # App entry point
├── Core/           # Infrastructure (navigation, theme, storage)
├── Features/       # App screens (Timetable, Info, Chat, Settings)
├── Models/         # Data models
└── Services/       # Business logic
```

---

## Related Projects

- [Weeztix](../Weeztix) - Festival analytics platform
- [Timetable2026](../Timetable2026) - Timetable generator

---

## License

© 2026 Iconic Festival. All rights reserved.

---

## Contact

- **Website**: https://www.iconicfestival.nl
- **Email**: info@iconicfestival.nl
- **Instagram**: @iconicfestival
- **Facebook**: IconicFestivalNL

# Development Guide

## Quick Start

1. Open the project:
   ```bash
   open Baseper.xcodeproj
   ```

2. In Xcode, select the "Baseper" scheme and "My Mac" destination

3. Press `⌘R` to build and run

4. Grant microphone permission when macOS prompts

5. Click the menu bar icon → Settings → paste your API key → Save

## Project Structure

```
baseper/
├── Baseper.xcodeproj/
├── Baseper/
│   ├── BaseperApp.swift              # App entry point, menu bar setup
│   ├── Views/
│   │   ├── MenuBarView.swift         # Main popover UI
│   │   └── SettingsView.swift        # Settings with model selection
│   ├── Models/
│   │   ├── TranscriptionViewModel.swift  # State management
│   │   └── TranscriptionChunk.swift      # Audio chunk model
│   ├── Services/
│   │   ├── TranscriptionProvider.swift   # Provider protocol
│   │   ├── ProviderManager.swift         # Provider selection
│   │   ├── GeminiService.swift           # Google Gemini API
│   │   ├── GroqService.swift             # Groq Whisper API
│   │   └── AudioCaptureService.swift     # Microphone capture
│   ├── Utilities/
│   │   └── KeychainManager.swift     # Local settings & API key storage
│   ├── Assets.xcassets/
│   ├── Info.plist
│   └── Baseper.entitlements
├── website/                          # Next.js marketing site
├── CLAUDE.md
├── README.md
├── LICENSE
└── Package.swift
```

## Making Changes

### UI
- `MenuBarView.swift` — main transcription interface
- `SettingsView.swift` — provider/model selection and API key entry

### Transcription
- `TranscriptionProvider.swift` — protocol all providers implement
- `GeminiService.swift` / `GroqService.swift` — API implementations
- `ProviderManager.swift` — manages provider selection and instantiation

### Audio
- `AudioCaptureService.swift` — AVAudioEngine microphone capture
- Format: 16kHz, 16-bit PCM, mono

## Debugging

Add print statements in:
- `GeminiService.handleMessage()` — see API responses
- `AudioCaptureService.processAudioBuffer()` — check audio flow
- `TranscriptionViewModel` — track state changes

## Building for Release

```bash
xcodebuild -project Baseper.xcodeproj \
  -scheme Baseper \
  -configuration Release \
  build
```

## Code Style

- SwiftUI for all UI
- `async/await` for async operations
- Services as `actor` for thread safety
- ViewModels as `@MainActor`

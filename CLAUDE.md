# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Repository Structure**: Monorepo containing the macOS app and marketing website.

### Baseper macOS App (`/Baseper`)
Native macOS menu bar app for live voice transcription.

The app captures audio from the microphone, streams it to transcription APIs (Groq or Gemini), and displays real-time transcription in a popover menu bar interface.

### Marketing Website (`/website`)
Next.js 14 landing page showcasing the app features, setup guide, and download links.

Built with React, TypeScript, and Tailwind CSS. Deployed on Vercel.

**Development**:
```bash
cd website
npm install
npm run dev  # Visit http://localhost:3000
```

## Technology Stack

- **Language**: Swift 5.0
- **UI Framework**: SwiftUI
- **Audio**: AVFoundation (AVAudioEngine for capture, 16-bit PCM at 16kHz)
- **API**: Gemini 1.5 Flash Live API (WebSocket via URLSession)
- **Storage**: UserDefaults for API keys and settings (local plist)
- **Minimum macOS**: 13.0 (Ventura)

## Build & Run Commands

### Open in Xcode
```bash
open Baseper.xcodeproj
```

### Build from Command Line
```bash
xcodebuild -project Baseper.xcodeproj -scheme Baseper -configuration Debug build
```

### Build for Release
```bash
xcodebuild -project Baseper.xcodeproj -scheme Baseper -configuration Release build
```

### Archive for Distribution
```bash
xcodebuild -project Baseper.xcodeproj -scheme Baseper -configuration Release archive -archivePath ./build/Baseper.xcarchive
```

### Export Archive
```bash
xcodebuild -exportArchive -archivePath ./build/Baseper.xcarchive -exportPath ./build -exportOptionsPlist ExportOptions.plist
```

### Run from Xcode
Press `⌘R` or Product → Run

## Architecture

### Core Components

1. **BaseperApp.swift** (`@main` entry point)
   - AppDelegate manages the NSStatusItem (menu bar icon)
   - Creates and shows NSPopover with MenuBarView
   - Owns the TranscriptionViewModel

2. **TranscriptionViewModel** (Models/)
   - `@MainActor` observable object coordinating all services
   - Manages recording state, transcription text, API key status
   - Bridges AudioCaptureService → GeminiService → UI

3. **GeminiService** (Services/)
   - `actor` for thread-safe WebSocket handling
   - Connects to Gemini Live API: `wss://generativelanguage.googleapis.com/ws/...`
   - Sends setup message with `"model": "models/gemini-1.5-flash"`
   - Streams base64-encoded PCM audio chunks via `realtime_input`
   - Parses server responses for transcription text
   - Accumulates transcript and calls back to ViewModel

4. **AudioCaptureService** (Services/)
   - Uses AVAudioEngine to capture mic input
   - Installs tap on inputNode with 4096 buffer size
   - Converts audio to 16-bit PCM, 16kHz, mono (Gemini requirement)
   - Calls `onAudioData` callback with Data chunks

5. **KeychainManager** (Utilities/)
   - Singleton for local storage (uses UserDefaults despite the name)
   - Stored in `~/Library/Preferences/com.hazelguo.Baseper.plist`
   - Per-provider API key storage: `geminiAPIKey`, `groqAPIKey`

### Data Flow

```
User clicks Start
  → ViewModel.startRecording()
  → GeminiService.connect(apiKey) [establishes WebSocket]
  → AudioCaptureService.startRecording() [starts mic capture]
  → Audio tap fires → convert to PCM → onAudioData callback
  → ViewModel receives Data → GeminiService.sendAudio(Data)
  → GeminiService sends realtime_input message via WebSocket
  → Server responds with serverContent containing text parts
  → GeminiService accumulates transcript → calls onTranscript callback
  → ViewModel updates @Published transcriptionText
  → SwiftUI re-renders MenuBarView with new text
```

### Views

- **MenuBarView.swift**: Main popover UI with text editor, Start/Stop/Copy buttons, status indicator
- **SettingsView.swift**: Sheet for model selection and API key entry

## Key Implementation Details

### Gemini Live API Setup Message

The setup message uses:
- Model: `gemini-1.5-flash` (cheaper than 2.0)
- `input_audio_transcription: true` to enable transcription events
- System instruction: Tells model to only transcribe, no extra commentary
- Response modalities: `["TEXT"]`

### Audio Format

Gemini expects:
- **Format**: 16-bit PCM (signed integer)
- **Sample rate**: 16000 Hz
- **Channels**: 1 (mono)
- **Encoding**: Little Endian
- **Transmission**: Base64-encoded in `realtime_input.media_chunks`

### Security

- API keys stored locally in UserDefaults
- App Sandbox enabled with entitlements:
  - `com.apple.security.network.client` (for WebSocket)
  - `com.apple.security.device.audio-input` (for microphone)
- LSUIElement = true (menu bar only, no Dock icon)

### State Management

- ViewModel is `@MainActor` - all UI updates happen on main thread
- GeminiService is `actor` - WebSocket operations are isolated
- Audio callbacks use `Task { @MainActor in ... }` to bridge to UI thread

## Common Development Tasks

### Adding a New Gemini Model

Edit `GeminiService.swift:sendSetupMessage()`:
```swift
"model": "models/gemini-2.0-flash"  // Change here
```

### Changing Audio Sample Rate

1. Update `AudioCaptureService.swift:setupAudioEngine()`:
   ```swift
   sampleRate: 24000  // New rate
   ```
2. Ensure Gemini supports the new rate (16kHz is documented)

### Adding New UI Features

- Add properties to `TranscriptionViewModel` with `@Published`
- Update `MenuBarView` or create new views in `Views/`
- Wire up buttons to ViewModel methods

### Debugging WebSocket Messages

Add print statements in `GeminiService.handleMessage()` to see raw JSON:
```swift
print("Received: \(String(data: data, encoding: .utf8) ?? "invalid")")
```

## Distribution

### For Open Source Users

1. **Download pre-built app**: GitHub Releases (once CI is set up)
2. **First launch**: Right-click → Open (bypass Gatekeeper warning)
3. **Enter API key**: Click menu bar icon → Settings → paste key
4. **Grant mic permission**: macOS will prompt on first recording

### Building from Source

1. Clone repo: `git clone https://github.com/hazelguo/baseper.git`
2. Open in Xcode: `open Baseper/Baseper.xcodeproj`
3. Select "Baseper" scheme, "My Mac" destination
4. Press `⌘R` to build and run
5. Optional: Change DEVELOPMENT_TEAM in project settings for code signing

### Code Signing

- For personal use: Xcode default signing works
- For distribution: Need Apple Developer account ($99/year) or use ad-hoc signing
- Users will see "unidentified developer" warning unless app is notarized

## API Costs

Gemini 1.5 Flash (as of Jan 2025):
- Free tier: 15 requests per minute
- Paid: ~$0.075 per 1M tokens
- Audio: ~25 tokens/second = 90,000 tokens/hour
- **Cost**: ~$0.0067 per hour of transcription

## Troubleshooting

### WebSocket Connection Fails
- Check API key is valid at https://aistudio.google.com/app/apikey
- Ensure network allows WSS connections
- Check Gemini API quota/billing

### No Audio Captured
- Grant microphone permission in System Settings → Privacy & Security → Microphone
- Check default input device in System Settings → Sound
- Verify `AudioCaptureService` tap installation succeeds

### Transcription Not Appearing
- Check GeminiService is receiving `serverContent` messages
- Verify `input_audio_transcription: true` in setup message
- Ensure audio format matches Gemini requirements (16-bit PCM, 16kHz)

### App Won't Launch
- Check macOS version ≥ 13.0
- Verify entitlements allow sandbox, network, audio
- Check Console.app for crash logs


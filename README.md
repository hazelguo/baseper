# Baseper

Live voice transcription for macOS. Sits in your menu bar, and costs almost nothing.

Bring your own API key. No accounts, no subscriptions, no "enterprise plan" upsells.

## How it compares

| | Baseper | Otter.ai | Superwhisper | Wispr Flow | Whisper.cpp |
|---|---|---|---|---|---|
| **Price** | $0.02/hr (BYOK) | $17/mo | $10/mo | $15/mo | Free |
| **Subscription** | No | Yes | Yes | Yes | No |
| **Data privacy** | Your key, your data | Their servers | Local or cloud | Their servers | Fully local |
| **Open source** | Yes | No | No | No | Yes |
| **Works offline** | No | No | Yes (local mode) | No | Yes |
| **Setup effort** | Download + API key | Create account | Download + pay | Download + pay | Compile from source |
| **Native Mac app** | Yes | Web app | Yes | Yes | CLI |

**TL;DR:** Baseper gives you Whisper-level transcription for ~$0.02/hr with zero lock-in. No subscription, no account, no compiling from source.

## Features

- **Live transcription** — real-time speech-to-text from your microphone
- **Multiple providers** — Groq (Whisper) and Google Gemini, pick from a unified model list
- **Dirt cheap** — starting at $0.02/hr, or free within API free tiers
- **No data collection** — audio goes straight to the API you chose, nowhere else
- **Editable output** — fix mistakes before copying
- **One-click copy** — transcription to clipboard, done
- **Local storage** — API keys stored locally on your Mac, never sent anywhere except the API you chose

## Supported models

| Provider + Model | Cost/hr | Notes |
|---|---|---|
| Groq Distil-Whisper | $0.020 | English only, cheapest |
| Gemini 2.5 Flash Lite | $0.039 | Multilingual |
| Groq Whisper Large V3 Turbo | $0.040 | Multilingual, 216x real-time |

## Installation

### Download

Grab the `.dmg` from the [Releases page](https://github.com/hazelguo/baseper/releases).

> **First launch:** macOS will warn you about an "unidentified developer." This is normal for unsigned apps. Right-click the app, click **Open**, then click **Open** again. You only do this once.

### Build from source

```bash
git clone https://github.com/hazelguo/baseper.git
cd baseper
open Baseper.xcodeproj
# ⌘R to build and run
```

Requires macOS 13.0+ and Xcode 15.0+.

## Setup

1. Get a free API key:
   - **Groq**: [console.groq.com/keys](https://console.groq.com/keys)
   - **Google Gemini**: [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey)
2. Launch Baseper — it lives in your menu bar
3. Click the icon → Settings → pick a model → paste your API key → Save
4. Grant microphone permission when macOS asks

## Usage

1. Click the menu bar icon
2. Hit **Start**
3. Talk
4. Hit **Stop**
5. Edit if you want, then **Copy**

That's it. No onboarding wizard, no tutorial, no "create your workspace."

## Privacy

- API keys stored locally on your Mac
- Audio streams directly to your chosen API — Baseper never sees or stores it
- Zero analytics, zero tracking, zero telemetry
- Read the code yourself if you don't believe me — it's all here

## Repository structure

- **`/Baseper`** — native macOS app (Swift + SwiftUI)
- **`/website`** — landing page (Next.js + Tailwind CSS)

## Development

See [CLAUDE.md](CLAUDE.md) for architecture docs.

```bash
# Build the app
xcodebuild -project Baseper.xcodeproj -scheme Baseper -configuration Debug build

# Run the website
cd website && npm install && npm run dev
```

## License

Elastic License 2.0 — see [LICENSE](LICENSE).

Use it, modify it, learn from it. Just don't resell it or host it as a service.

## Acknowledgments

Built with SwiftUI and AVFoundation. Powered by [Groq](https://groq.com) and [Google Gemini](https://deepmind.google/technologies/gemini/).

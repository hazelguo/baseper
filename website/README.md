# Baseper Website

Marketing website for Baseper, the macOS voice transcription app.

## Tech Stack

- **Framework:** Next.js 14 (App Router)
- **Styling:** Tailwind CSS
- **Language:** TypeScript
- **Deployment:** Vercel (recommended)

## Development

### Prerequisites

- Node.js 18.x or later
- npm or yarn

### Getting Started

1. Install dependencies:
```bash
npm install
```

2. Run the development server:
```bash
npm run dev
```

3. Open [http://localhost:3000](http://localhost:3000) in your browser.

## Building for Production

```bash
npm run build
npm run start
```

## Deployment

### Vercel (Recommended)

1. Push changes to GitHub
2. Import the Baseper repository in Vercel
3. **Important**: Set "Root Directory" to `website` in project settings
4. Deploy automatically on push to main branch

### Manual Deployment

```bash
npm run build
# Deploy the `.next` folder to your hosting provider
```

## Project Structure

```
website/
├── app/
│   ├── layout.tsx       # Root layout with metadata
│   ├── page.tsx         # Landing page
│   └── globals.css      # Global styles
├── components/
│   ├── Hero.tsx         # Hero section with CTAs
│   ├── Demo.tsx         # Demo video
│   ├── Setup.tsx        # Installation guide
│   ├── Footer.tsx       # Footer links
│   ├── ManagedCTA.tsx   # Call-to-action component
│   ├── AnimatedBackground.tsx  # Background animations
│   └── ui/
│       └── Button.tsx   # Reusable button component
├── public/              # Static assets
└── package.json
```

## TODOs

- [ ] Add demo video (replace placeholder in `Demo.tsx`)
- [ ] Update Twitter handle in `OpenSource.tsx` (currently "TODO")
- [ ] Add logo to `public/` folder
- [ ] Add GitHub star count API integration (optional)
- [ ] Add screenshots to `public/` folder

## License

MIT - see [LICENSE](../LICENSE)

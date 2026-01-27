import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Baseper — Free Speech to Text App for Mac | $0.02/hr, Open Source",
  description: "Open source macOS menu bar app for real-time speech-to-text. Bring your own API key — starting at $0.02/hr. No subscription, no data collection.",
  keywords: ["transcription", "speech to text", "voice to text", "macOS", "menu bar app", "dictation", "open source", "BYOK", "voice transcription", "mac transcription app", "otter.ai alternative", "wispr flow alternative"],
  openGraph: {
    title: "Baseper — Free Speech to Text App for Mac | Open Source",
    description: "Open source menu bar app for real-time speech-to-text. Bring your own API key, starting at $0.02/hr.",
    type: "website",
    url: "https://baseper.com",
    siteName: "Baseper",
  },
  twitter: {
    card: "summary_large_image",
    title: "Baseper — Free Speech to Text App for Mac | Open Source",
    description: "Open source menu bar app for real-time speech-to-text. Bring your own API key, starting at $0.02/hr.",
  },
  metadataBase: new URL("https://baseper.com"),
  alternates: {
    canonical: "https://baseper.com",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "SoftwareApplication",
              name: "Baseper",
              operatingSystem: "macOS",
              applicationCategory: "UtilitiesApplication",
              description: "Open source macOS menu bar app for real-time voice transcription. Bring your own API key.",
              offers: {
                "@type": "Offer",
                price: "0",
                priceCurrency: "USD",
              },
              url: "https://baseper.com",
              downloadUrl: "https://github.com/hazelguo/baseper/releases",
            }),
          }}
        />
      </head>
      <body className="antialiased">
        {children}
      </body>
    </html>
  );
}

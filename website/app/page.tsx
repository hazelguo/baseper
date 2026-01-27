import Hero from "@/components/Hero";
import Demo from "@/components/Demo";
import Comparison from "@/components/Comparison";
import Setup from "@/components/Setup";
import Footer from "@/components/Footer";
import ManagedCTA from "@/components/ManagedCTA";
import FAQ from "@/components/FAQ";
import BackgroundOrbs from "@/components/BackgroundOrbs";

export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-b from-blue-50 via-white to-gray-50 dark:from-gray-900 dark:via-gray-950 dark:to-black relative">
      <BackgroundOrbs />

      <div className="relative z-10">
        <Hero />
        {/* <Demo /> */}
        <Comparison />
        <Setup />
        <ManagedCTA />
        <FAQ />
        <Footer />
      </div>
    </main>
  );
}

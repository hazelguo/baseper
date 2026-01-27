export default function ManagedCTA() {
  return (
    <section className="py-20 sm:py-28 bg-transparent">
      <div className="mx-auto max-w-3xl px-6 lg:px-8 text-center">
        <p className="text-sm font-medium uppercase tracking-wider text-purple-600 dark:text-purple-400 mb-4">
          Coming soon
        </p>
        <h2 className="text-2xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-3xl">
          Don&apos;t want to manage API keys?
        </h2>
        <p className="mt-4 text-lg text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">
          I&apos;m exploring a managed version — same great transcription, zero setup.<br />
          You&apos;d only pay for what you use. No monthly fee.<br />
          Leave your email and I&apos;ll let you know when it&apos;s ready.
        </p>
        <a
          href="https://hazelguo.notion.site/2f8553a2684180afaa62d83148d1ce8c?pvs=105"
          target="_blank"
          rel="noopener noreferrer"
          className="mt-8 inline-flex items-center gap-2 px-6 py-3 rounded-lg text-base font-medium text-purple-700 dark:text-purple-300 bg-purple-50 dark:bg-purple-900/30 hover:bg-purple-100 dark:hover:bg-purple-900/50 transition-colors"
        >
          Keep me in the loop
          <svg className="w-4 h-4" fill="none" viewBox="0 0 24 24" strokeWidth={2} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M13.5 4.5 21 12m0 0-7.5 7.5M21 12H3" />
          </svg>
        </a>
        <p className="mt-4 text-xs text-gray-400 dark:text-gray-600">
          No spam. Just gauging interest.
        </p>
      </div>
    </section>
  );
}

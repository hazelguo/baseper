const faqs = [
  {
    question: "Is Baseper free?",
    answer: "The app is free and open source. You pay only for API usage — starting at $0.02/hr with Groq's free tier, or free within Google Gemini's generous free tier."
  },
  {
    question: "How is Baseper different from Otter.ai or Wispr Flow?",
    answer: "Baseper has no subscription — you bring your own API key and pay per use. There's no account to create, no data stored on third-party servers, and the source code is fully open for inspection."
  },
  {
    question: "How accurate is the transcription?",
    answer: "Baseper uses the same Whisper models that power most commercial transcription apps. Accuracy depends on the model you choose — Whisper Large V3 Turbo offers near state-of-the-art results."
  },
  {
    question: "Does Baseper work offline?",
    answer: "No. Baseper streams audio to a cloud API for transcription. If you need offline transcription, consider Whisper.cpp or Superwhisper's local mode."
  },
  {
    question: "Is my audio data private?",
    answer: "Baseper sends audio directly to the API provider you choose (Groq or Google Gemini). Nothing passes through Baseper's servers — there are no Baseper servers. Your API key is stored locally on your Mac."
  },
  {
    question: "What API key do I need?",
    answer: "Either a Groq API key (free at console.groq.com) or a Google Gemini API key (free at aistudio.google.com). Both offer free tiers that are more than enough for personal use."
  },
];

export default function FAQ() {
  return (
    <section className="py-24 sm:py-32 bg-transparent">
      <div className="mx-auto max-w-3xl px-6 lg:px-8">
        <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl text-center mb-12">
          Frequently asked questions
        </h2>

        <dl className="space-y-8">
          {faqs.map((faq, i) => (
            <div key={i}>
              <dt className="text-lg font-semibold text-gray-900 dark:text-white">
                {faq.question}
              </dt>
              <dd className="mt-2 text-gray-600 dark:text-gray-400">
                {faq.answer}
              </dd>
            </div>
          ))}
        </dl>
      </div>

      {/* FAQ Schema for Google rich results */}
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{
          __html: JSON.stringify({
            "@context": "https://schema.org",
            "@type": "FAQPage",
            mainEntity: faqs.map((faq) => ({
              "@type": "Question",
              name: faq.question,
              acceptedAnswer: {
                "@type": "Answer",
                text: faq.answer,
              },
            })),
          }),
        }}
      />
    </section>
  );
}

import Button from "./ui/Button";

export default function Setup() {
  return (
    <section className="py-32 sm:py-40 bg-transparent">
      <div className="mx-auto max-w-4xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl text-center mb-16">
          <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl mb-6">
            Set up in 2 minutes
          </h2>
          <div className="mb-12">
            <Button
              variant="primary"
              size="lg"
              href="https://github.com/hazelguo/baseper/releases"
            >
              Download for macOS
            </Button>
          </div>
        </div>

        <div className="mx-auto max-w-3xl space-y-8">
          {/* Step 1 */}
          <div className="flex gap-6">
            <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-semibold">
              1
            </div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                First launch: Bypass Gatekeeper
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                macOS will show "unidentified developer" warning. This is normal for unsigned apps.{" "}
                <strong>Right-click the app → Open</strong> to launch it.
              </p>
            </div>
          </div>

          {/* Step 2 */}
          <div className="flex gap-6">
            <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-semibold">
              2
            </div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                Get your API key
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                Get a free API key from{" "}
                <a
                  href="https://console.groq.com/keys"
                  className="text-blue-600 dark:text-blue-400 hover:underline"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Groq
                </a>{" "}
                or{" "}
                <a
                  href="https://aistudio.google.com/app/apikey"
                  className="text-blue-600 dark:text-blue-400 hover:underline"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Google AI Studio
                </a>
                . Pick a model in Baseper's settings and paste your key.
              </p>
            </div>
          </div>

          {/* Step 3 */}
          <div className="flex gap-6">
            <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-semibold">
              3
            </div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                Grant microphone access
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                On first recording, macOS will ask for microphone permission. Click "OK" to allow.
              </p>
            </div>
          </div>

          {/* Step 4 */}
          <div className="flex gap-6">
            <div className="flex-shrink-0 w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/30 flex items-center justify-center text-blue-600 dark:text-blue-400 font-semibold">
              4
            </div>
            <div>
              <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">
                Start transcribing
              </h3>
              <p className="text-gray-600 dark:text-gray-400">
                Click the Baseper icon in your menu bar, hit Start, and speak. Your transcription appears in real-time!
              </p>
            </div>
          </div>
        </div>

        <div className="mt-12 text-center">
          <a
            href="https://github.com/hazelguo/baseper#readme"
            className="text-sm text-gray-500 dark:text-gray-500 hover:text-gray-700 dark:hover:text-gray-300 underline"
          >
            View full documentation on GitHub →
          </a>
        </div>
      </div>
    </section>
  );
}

export default function Demo() {
  return (
    <section className="py-32 sm:py-40 bg-transparent">
      <div className="mx-auto max-w-6xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl text-center mb-16">
          <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl">
            See it in action
          </h2>
        </div>
        <div className="mx-auto max-w-5xl">
          <div className="aspect-video rounded-2xl bg-gradient-to-br from-gray-100 to-gray-200 dark:from-gray-800 dark:to-gray-900 flex items-center justify-center border border-gray-300/50 dark:border-gray-700/50 shadow-xl">
            <div className="text-center px-8">
              <div className="text-5xl mb-4 opacity-40">🎥</div>
              <p className="text-lg font-medium text-gray-500 dark:text-gray-400">
                Demo video coming soon
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

'use client';

import { useEffect, useState } from 'react';

const competitors = ["Otter.ai", "Superwhisper", "Wispr Flow", "Whisper.cpp"];

export default function Comparison() {
  const [index, setIndex] = useState(0);
  const [isSliding, setIsSliding] = useState(false);
  const [transitioning, setTransitioning] = useState(true);

  useEffect(() => {
    const interval = setInterval(() => {
      // Enable transition, then slide up
      setTransitioning(true);
      setIsSliding(true);

      // After slide completes: disable transition, snap index, reset position
      setTimeout(() => {
        setTransitioning(false);
        setIndex((prev) => (prev + 1) % competitors.length);
        setIsSliding(false);
      }, 500);
    }, 2500);

    return () => clearInterval(interval);
  }, []);

  const currentName = competitors[index];
  const nextName = competitors[(index + 1) % competitors.length];

  return (
    <section className="py-32 sm:py-40 bg-transparent">
      <div className="mx-auto max-w-5xl px-6 lg:px-8">
        <div className="mx-auto max-w-2xl text-center mb-16">
          <h2 className="text-3xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-4xl flex items-center justify-center gap-3">
            <span>Baseper vs</span>
            <span className="inline-block h-[1.2em] overflow-hidden relative text-left" style={{ width: '6.5em' }}>
              <span
                className="flex flex-col"
                style={{
                  transform: isSliding ? 'translateY(-50%)' : 'translateY(0)',
                  transition: transitioning ? 'transform 500ms ease-in-out' : 'none',
                }}
              >
                <span className="h-[1.2em] flex items-center text-purple-600 dark:text-purple-400">
                  {currentName}
                </span>
                <span className="h-[1.2em] flex items-center text-purple-600 dark:text-purple-400">
                  {nextName}
                </span>
              </span>
            </span>
          </h2>
          <p className="mt-4 text-lg text-gray-600 dark:text-gray-400">
            See how the best macOS transcription apps compare.
          </p>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead>
              <tr className="border-b border-gray-200 dark:border-gray-700">
                <th className="py-4 pr-4 font-medium text-gray-500 dark:text-gray-400"></th>
                <th className="py-4 px-4 font-semibold text-gray-900 dark:text-white">Baseper</th>
                <th className="py-4 px-4 font-medium text-gray-600 dark:text-gray-300">Otter.ai</th>
                <th className="py-4 px-4 font-medium text-gray-600 dark:text-gray-300">Superwhisper</th>
                <th className="py-4 px-4 font-medium text-gray-600 dark:text-gray-300">Wispr Flow</th>
                <th className="py-4 px-4 font-medium text-gray-600 dark:text-gray-300">Whisper.cpp</th>
              </tr>
            </thead>
            <tbody className="text-gray-600 dark:text-gray-400">
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Price</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">$0.02/hr</td>
                <td className="py-3 px-4">$17/mo</td>
                <td className="py-3 px-4">$10/mo</td>
                <td className="py-3 px-4">$15/mo</td>
                <td className="py-3 px-4">Free</td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Subscription</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">No</td>
                <td className="py-3 px-4">Yes</td>
                <td className="py-3 px-4">Yes</td>
                <td className="py-3 px-4">Yes</td>
                <td className="py-3 px-4">No</td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Data privacy</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">Your key, your data</td>
                <td className="py-3 px-4">Their servers</td>
                <td className="py-3 px-4">Local or cloud</td>
                <td className="py-3 px-4">Their servers</td>
                <td className="py-3 px-4">Fully local</td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Open source</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">Yes</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">Yes</td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Works offline</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">Yes (local mode)</td>
                <td className="py-3 px-4">No</td>
                <td className="py-3 px-4">Yes</td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-800">
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Setup effort</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">Download + API key</td>
                <td className="py-3 px-4">Create account</td>
                <td className="py-3 px-4">Download + pay</td>
                <td className="py-3 px-4">Download + pay</td>
                <td className="py-3 px-4">Compile from source</td>
              </tr>
              <tr>
                <td className="py-3 pr-4 font-medium text-gray-900 dark:text-white">Native Mac app</td>
                <td className="py-3 px-4 font-semibold text-gray-900 dark:text-white">Yes</td>
                <td className="py-3 px-4">Web app</td>
                <td className="py-3 px-4">Yes</td>
                <td className="py-3 px-4">Yes</td>
                <td className="py-3 px-4">CLI</td>
              </tr>
            </tbody>
          </table>
        </div>

        <p className="mt-8 text-center text-sm text-gray-500 dark:text-gray-500">
          The only open source transcription app with pay-per-use pricing and a native Mac interface.
        </p>
      </div>
    </section>
  );
}

'use client';

export default function AnimatedBackground() {
  return (
    <div className="absolute inset-0 -z-10 overflow-hidden">
      {/* TEST: Bright visible circle to verify component is rendering */}
      <div className="absolute top-10 left-10 w-32 h-32 bg-red-500 rounded-full animate-blob"></div>

      {/* Gradient Orbs - More Visible */}
      <div className="absolute top-10 left-1/4 w-96 h-96 bg-purple-400 dark:bg-purple-500 rounded-full mix-blend-multiply dark:mix-blend-normal filter blur-3xl opacity-50 dark:opacity-30 animate-blob"></div>
      <div className="absolute top-20 right-1/4 w-96 h-96 bg-blue-400 dark:bg-blue-500 rounded-full mix-blend-multiply dark:mix-blend-normal filter blur-3xl opacity-50 dark:opacity-30 animate-blob animation-delay-2000"></div>
      <div className="absolute top-40 left-1/2 w-96 h-96 bg-pink-400 dark:bg-pink-500 rounded-full mix-blend-multiply dark:mix-blend-normal filter blur-3xl opacity-50 dark:opacity-30 animate-blob animation-delay-4000"></div>

      {/* Grid Pattern Overlay */}
      <div className="absolute inset-0 bg-grid-pattern opacity-[0.03] dark:opacity-[0.08]"></div>
    </div>
  );
}

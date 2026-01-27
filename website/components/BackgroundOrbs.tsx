'use client';

export default function BackgroundOrbs() {
  return (
    <div className="fixed inset-0 overflow-hidden pointer-events-none" aria-hidden="true">
      <div className="absolute top-1/4 left-10 w-[600px] h-[600px] bg-blue-200/50 dark:bg-blue-900/50 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '40s' }}></div>
      <div className="absolute top-1/2 right-10 w-[700px] h-[700px] bg-purple-200/45 dark:bg-purple-900/45 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '45s' }}></div>
      <div className="absolute bottom-1/4 left-1/3 w-[500px] h-[500px] bg-indigo-200/40 dark:bg-indigo-900/40 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '38s' }}></div>
      <div className="absolute top-2/3 right-1/4 w-[450px] h-[450px] bg-cyan-200/38 dark:bg-cyan-900/38 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '42s' }}></div>
    </div>
  );
}

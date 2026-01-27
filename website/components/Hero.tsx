'use client';

import Button from "./ui/Button";

export default function Hero() {
  return (
    <section className="relative overflow-visible bg-transparent pt-20 pb-32 sm:pt-32 sm:pb-40">
      {/* Animated Background - Layered animations */}
      <div className="absolute inset-0 overflow-visible pointer-events-none">
        {/* Layer 1: Subtle gradient blobs */}
        <div className="absolute top-20 left-10 w-[700px] h-[700px] bg-blue-200/60 dark:bg-blue-900/60 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '30s' }}></div>
        <div className="absolute top-10 right-10 w-[650px] h-[650px] bg-purple-200/50 dark:bg-purple-900/50 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '35s' }}></div>
        <div className="absolute top-32 left-1/4 w-[550px] h-[550px] bg-indigo-200/55 dark:bg-indigo-900/55 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '25s' }}></div>
        <div className="absolute top-24 right-1/3 w-[500px] h-[500px] bg-cyan-200/45 dark:bg-cyan-900/45 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '28s' }}></div>
        <div className="absolute top-40 left-1/2 w-[400px] h-[400px] bg-violet-200/50 dark:bg-violet-900/50 rounded-full mix-blend-normal filter blur-3xl animate-flow" style={{ animationDuration: '20s' }}></div>
        <div className="absolute top-16 right-1/4 w-[350px] h-[350px] bg-sky-200/40 dark:bg-sky-900/40 rounded-full mix-blend-normal filter blur-2xl animate-flow" style={{ animationDuration: '22s' }}></div>

        {/* Layer 2: Flowing curved lines - optimized for continuous presence */}
        <svg className="absolute inset-0 w-full h-full animate-fade-in-slow" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
          <defs>
            <linearGradient id="lineGradient1" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(59, 130, 246)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(59, 130, 246)', stopOpacity: 0.4 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(59, 130, 246)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient2" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(168, 85, 247)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(168, 85, 247)', stopOpacity: 0.35 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(168, 85, 247)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient3" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(99, 102, 241)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(99, 102, 241)', stopOpacity: 0.3 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(99, 102, 241)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient4" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(34, 211, 238)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(34, 211, 238)', stopOpacity: 0.25 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(34, 211, 238)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient5" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(139, 92, 246)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(139, 92, 246)', stopOpacity: 0.38 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(139, 92, 246)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient6" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(147, 197, 253)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(147, 197, 253)', stopOpacity: 0.28 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(147, 197, 253)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient7" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(196, 181, 253)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(196, 181, 253)', stopOpacity: 0.32 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(196, 181, 253)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient8" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(96, 165, 250)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(96, 165, 250)', stopOpacity: 0.28 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(96, 165, 250)', stopOpacity: 0 }} />
            </linearGradient>
            <linearGradient id="lineGradient9" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style={{ stopColor: 'rgb(167, 139, 250)', stopOpacity: 0 }} />
              <stop offset="50%" style={{ stopColor: 'rgb(167, 139, 250)', stopOpacity: 0.35 }} />
              <stop offset="100%" style={{ stopColor: 'rgb(167, 139, 250)', stopOpacity: 0 }} />
            </linearGradient>
          </defs>

          {/* 80 flowing lines — half L→R, half R→L for balanced screen presence */}
          <path className="animate-flow-line"         d="M -500 255 Q 180 221, 900 275"   stroke="url(#lineGradient1)" strokeWidth="1.4" fill="none" style={{ animationDuration: '27s', animationDelay: '-0.3s' }} />
          <path className="animate-flow-line-reverse" d="M -500 420 Q 350 458, 900 402"   stroke="url(#lineGradient5)" strokeWidth="1.8" fill="none" style={{ animationDuration: '25s', animationDelay: '-2.0s' }} />
          <path className="animate-flow-line"         d="M -500 330 Q 450 297, 900 350"   stroke="url(#lineGradient9)" strokeWidth="1.3" fill="none" style={{ animationDuration: '28s', animationDelay: '-3.4s' }} />
          <path className="animate-flow-line-reverse" d="M -500 380 Q 130 413, 900 362"   stroke="url(#lineGradient3)" strokeWidth="1.8" fill="none" style={{ animationDuration: '24s', animationDelay: '-5.1s' }} />
          <path className="animate-flow-line"         d="M -500 365 Q 400 331, 900 385"   stroke="url(#lineGradient7)" strokeWidth="1.5" fill="none" style={{ animationDuration: '26s', animationDelay: '-6.5s' }} />
          <path className="animate-flow-line-reverse" d="M -500 270 Q 220 303, 900 252"   stroke="url(#lineGradient2)" strokeWidth="2.1" fill="none" style={{ animationDuration: '27s', animationDelay: '-8.2s' }} />
          <path className="animate-flow-line"         d="M -500 435 Q 300 401, 900 452"   stroke="url(#lineGradient6)" strokeWidth="1.3" fill="none" style={{ animationDuration: '25s', animationDelay: '-9.7s' }} />
          <path className="animate-flow-line-reverse" d="M -500 305 Q 480 340, 900 288"   stroke="url(#lineGradient4)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-11.0s' }} />
          <path className="animate-flow-line-reverse" d="M -500 440 Q 160 473, 900 422"   stroke="url(#lineGradient8)" strokeWidth="1.6" fill="none" style={{ animationDuration: '24s', animationDelay: '-12.8s' }} />
          <path className="animate-flow-line"         d="M -500 290 Q 370 257, 900 310"   stroke="url(#lineGradient1)" strokeWidth="2.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-14.1s' }} />
          <path className="animate-flow-line-reverse" d="M -500 395 Q 240 430, 900 378"   stroke="url(#lineGradient5)" strokeWidth="1.3" fill="none" style={{ animationDuration: '27s', animationDelay: '-15.6s' }} />
          <path className="animate-flow-line"         d="M -500 260 Q 420 227, 900 280"   stroke="url(#lineGradient9)" strokeWidth="1.7" fill="none" style={{ animationDuration: '25s', animationDelay: '-17.2s' }} />
          <path className="animate-flow-line-reverse" d="M -500 315 Q 140 350, 900 298"   stroke="url(#lineGradient3)" strokeWidth="2.2" fill="none" style={{ animationDuration: '28s', animationDelay: '-18.5s' }} />
          <path className="animate-flow-line"         d="M -500 410 Q 310 377, 900 428"   stroke="url(#lineGradient7)" strokeWidth="1.3" fill="none" style={{ animationDuration: '24s', animationDelay: '-20.3s' }} />
          <path className="animate-flow-line-reverse" d="M -500 345 Q 460 380, 900 328"   stroke="url(#lineGradient2)" strokeWidth="1.5" fill="none" style={{ animationDuration: '26s', animationDelay: '-21.7s' }} />
          <path className="animate-flow-line"         d="M -500 275 Q 200 241, 900 295"   stroke="url(#lineGradient6)" strokeWidth="1.8" fill="none" style={{ animationDuration: '27s', animationDelay: '-23.4s' }} />

          <path className="animate-flow-line"         d="M -500 260 Q 200 226, 900 280"   stroke="url(#lineGradient2)" strokeWidth="1.5" fill="none" style={{ animationDuration: '25s', animationDelay: '-0.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 425 Q 320 463, 900 407"   stroke="url(#lineGradient6)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-2.5s' }} />
          <path className="animate-flow-line"         d="M -500 335 Q 420 302, 900 355"   stroke="url(#lineGradient4)" strokeWidth="1.6" fill="none" style={{ animationDuration: '24s', animationDelay: '-3.9s' }} />
          <path className="animate-flow-line-reverse" d="M -500 385 Q 160 418, 900 367"   stroke="url(#lineGradient8)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-5.6s' }} />
          <path className="animate-flow-line"         d="M -500 370 Q 370 336, 900 390"   stroke="url(#lineGradient1)" strokeWidth="2.1" fill="none" style={{ animationDuration: '27s', animationDelay: '-7.0s' }} />
          <path className="animate-flow-line-reverse" d="M -500 275 Q 250 308, 900 257"   stroke="url(#lineGradient9)" strokeWidth="1.3" fill="none" style={{ animationDuration: '25s', animationDelay: '-8.7s' }} />
          <path className="animate-flow-line"         d="M -500 440 Q 280 406, 900 457"   stroke="url(#lineGradient3)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-10.2s' }} />
          <path className="animate-flow-line-reverse" d="M -500 310 Q 450 345, 900 293"   stroke="url(#lineGradient7)" strokeWidth="2.3" fill="none" style={{ animationDuration: '24s', animationDelay: '-11.5s' }} />
          <path className="animate-flow-line-reverse" d="M -500 445 Q 190 478, 900 427"   stroke="url(#lineGradient5)" strokeWidth="1.4" fill="none" style={{ animationDuration: '26s', animationDelay: '-13.3s' }} />
          <path className="animate-flow-line"         d="M -500 295 Q 340 262, 900 315"   stroke="url(#lineGradient2)" strokeWidth="1.8" fill="none" style={{ animationDuration: '27s', animationDelay: '-14.6s' }} />
          <path className="animate-flow-line-reverse" d="M -500 400 Q 210 435, 900 383"   stroke="url(#lineGradient6)" strokeWidth="2.2" fill="none" style={{ animationDuration: '25s', animationDelay: '-16.1s' }} />
          <path className="animate-flow-line"         d="M -500 265 Q 390 232, 900 285"   stroke="url(#lineGradient4)" strokeWidth="1.3" fill="none" style={{ animationDuration: '28s', animationDelay: '-17.7s' }} />
          <path className="animate-flow-line-reverse" d="M -500 320 Q 170 355, 900 303"   stroke="url(#lineGradient8)" strokeWidth="1.6" fill="none" style={{ animationDuration: '24s', animationDelay: '-19.0s' }} />
          <path className="animate-flow-line"         d="M -500 415 Q 280 382, 900 433"   stroke="url(#lineGradient9)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-20.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 350 Q 430 385, 900 333"   stroke="url(#lineGradient1)" strokeWidth="1.8" fill="none" style={{ animationDuration: '27s', animationDelay: '-22.2s' }} />
          <path className="animate-flow-line"         d="M -500 280 Q 230 246, 900 300"   stroke="url(#lineGradient3)" strokeWidth="1.5" fill="none" style={{ animationDuration: '25s', animationDelay: '-23.9s' }} />

          <path className="animate-flow-line-reverse" d="M -500 265 Q 240 231, 900 285"   stroke="url(#lineGradient7)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-1.3s' }} />
          <path className="animate-flow-line"         d="M -500 430 Q 380 468, 900 412"   stroke="url(#lineGradient3)" strokeWidth="1.3" fill="none" style={{ animationDuration: '24s', animationDelay: '-3.0s' }} />
          <path className="animate-flow-line-reverse" d="M -500 340 Q 470 307, 900 360"   stroke="url(#lineGradient6)" strokeWidth="2.2" fill="none" style={{ animationDuration: '26s', animationDelay: '-4.4s' }} />
          <path className="animate-flow-line"         d="M -500 390 Q 110 423, 900 372"   stroke="url(#lineGradient1)" strokeWidth="1.3" fill="none" style={{ animationDuration: '27s', animationDelay: '-6.1s' }} />
          <path className="animate-flow-line-reverse" d="M -500 375 Q 360 341, 900 395"   stroke="url(#lineGradient5)" strokeWidth="1.7" fill="none" style={{ animationDuration: '25s', animationDelay: '-7.5s' }} />
          <path className="animate-flow-line"         d="M -500 280 Q 190 313, 900 262"   stroke="url(#lineGradient8)" strokeWidth="1.4" fill="none" style={{ animationDuration: '28s', animationDelay: '-9.2s' }} />
          <path className="animate-flow-line-reverse" d="M -500 445 Q 330 411, 900 462"   stroke="url(#lineGradient2)" strokeWidth="2.3" fill="none" style={{ animationDuration: '24s', animationDelay: '-10.7s' }} />
          <path className="animate-flow-line"         d="M -500 315 Q 440 350, 900 298"   stroke="url(#lineGradient9)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-12.0s' }} />
          <path className="animate-flow-line"         d="M -500 450 Q 200 483, 900 432"   stroke="url(#lineGradient4)" strokeWidth="1.8" fill="none" style={{ animationDuration: '27s', animationDelay: '-13.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 300 Q 310 267, 900 320"   stroke="url(#lineGradient7)" strokeWidth="1.5" fill="none" style={{ animationDuration: '25s', animationDelay: '-15.1s' }} />
          <path className="animate-flow-line"         d="M -500 405 Q 270 440, 900 388"   stroke="url(#lineGradient3)" strokeWidth="1.8" fill="none" style={{ animationDuration: '28s', animationDelay: '-16.6s' }} />
          <path className="animate-flow-line-reverse" d="M -500 270 Q 450 237, 900 290"   stroke="url(#lineGradient5)" strokeWidth="1.6" fill="none" style={{ animationDuration: '24s', animationDelay: '-18.2s' }} />
          <path className="animate-flow-line"         d="M -500 325 Q 120 360, 900 308"   stroke="url(#lineGradient6)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-19.5s' }} />
          <path className="animate-flow-line-reverse" d="M -500 420 Q 350 387, 900 438"   stroke="url(#lineGradient8)" strokeWidth="2.1" fill="none" style={{ animationDuration: '27s', animationDelay: '-21.3s' }} />
          <path className="animate-flow-line"         d="M -500 355 Q 480 390, 900 338"   stroke="url(#lineGradient1)" strokeWidth="1.3" fill="none" style={{ animationDuration: '25s', animationDelay: '-22.7s' }} />
          <path className="animate-flow-line-reverse" d="M -500 285 Q 170 251, 900 305"   stroke="url(#lineGradient9)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-24.4s' }} />

          <path className="animate-flow-line"         d="M -500 270 Q 260 236, 900 290"   stroke="url(#lineGradient4)" strokeWidth="2.1" fill="none" style={{ animationDuration: '24s', animationDelay: '-1.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 435 Q 300 473, 900 417"   stroke="url(#lineGradient8)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-3.5s' }} />
          <path className="animate-flow-line"         d="M -500 345 Q 410 312, 900 365"   stroke="url(#lineGradient2)" strokeWidth="1.8" fill="none" style={{ animationDuration: '27s', animationDelay: '-4.9s' }} />
          <path className="animate-flow-line-reverse" d="M -500 395 Q 150 428, 900 377"   stroke="url(#lineGradient6)" strokeWidth="1.5" fill="none" style={{ animationDuration: '25s', animationDelay: '-6.6s' }} />
          <path className="animate-flow-line"         d="M -500 380 Q 340 346, 900 400"   stroke="url(#lineGradient9)" strokeWidth="2.3" fill="none" style={{ animationDuration: '28s', animationDelay: '-8.0s' }} />
          <path className="animate-flow-line-reverse" d="M -500 285 Q 210 318, 900 267"   stroke="url(#lineGradient3)" strokeWidth="1.4" fill="none" style={{ animationDuration: '24s', animationDelay: '-9.7s' }} />
          <path className="animate-flow-line"         d="M -500 450 Q 370 416, 900 467"   stroke="url(#lineGradient7)" strokeWidth="1.6" fill="none" style={{ animationDuration: '26s', animationDelay: '-11.2s' }} />
          <path className="animate-flow-line-reverse" d="M -500 320 Q 460 355, 900 303"   stroke="url(#lineGradient1)" strokeWidth="1.3" fill="none" style={{ animationDuration: '27s', animationDelay: '-12.5s' }} />
          <path className="animate-flow-line-reverse" d="M -500 455 Q 230 488, 900 437"   stroke="url(#lineGradient5)" strokeWidth="1.8" fill="none" style={{ animationDuration: '25s', animationDelay: '-14.3s' }} />
          <path className="animate-flow-line"         d="M -500 305 Q 390 272, 900 325"   stroke="url(#lineGradient4)" strokeWidth="1.3" fill="none" style={{ animationDuration: '28s', animationDelay: '-15.6s' }} />
          <path className="animate-flow-line-reverse" d="M -500 410 Q 180 445, 900 393"   stroke="url(#lineGradient8)" strokeWidth="1.7" fill="none" style={{ animationDuration: '24s', animationDelay: '-17.1s' }} />
          <path className="animate-flow-line"         d="M -500 275 Q 440 242, 900 295"   stroke="url(#lineGradient2)" strokeWidth="2.2" fill="none" style={{ animationDuration: '26s', animationDelay: '-18.7s' }} />
          <path className="animate-flow-line-reverse" d="M -500 330 Q 130 365, 900 313"   stroke="url(#lineGradient6)" strokeWidth="1.3" fill="none" style={{ animationDuration: '27s', animationDelay: '-20.0s' }} />
          <path className="animate-flow-line"         d="M -500 425 Q 290 392, 900 443"   stroke="url(#lineGradient5)" strokeWidth="1.7" fill="none" style={{ animationDuration: '25s', animationDelay: '-21.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 360 Q 400 395, 900 343"   stroke="url(#lineGradient7)" strokeWidth="1.4" fill="none" style={{ animationDuration: '28s', animationDelay: '-23.2s' }} />
          <path className="animate-flow-line"         d="M -500 290 Q 170 256, 900 310"   stroke="url(#lineGradient9)" strokeWidth="1.6" fill="none" style={{ animationDuration: '24s', animationDelay: '-24.9s' }} />

          <path className="animate-flow-line-reverse" d="M -500 275 Q 290 241, 900 295"   stroke="url(#lineGradient6)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-2.3s' }} />
          <path className="animate-flow-line"         d="M -500 440 Q 410 478, 900 422"   stroke="url(#lineGradient1)" strokeWidth="2.2" fill="none" style={{ animationDuration: '27s', animationDelay: '-4.0s' }} />
          <path className="animate-flow-line-reverse" d="M -500 350 Q 180 317, 900 370"   stroke="url(#lineGradient8)" strokeWidth="1.5" fill="none" style={{ animationDuration: '25s', animationDelay: '-5.4s' }} />
          <path className="animate-flow-line"         d="M -500 400 Q 470 433, 900 382"   stroke="url(#lineGradient4)" strokeWidth="1.7" fill="none" style={{ animationDuration: '28s', animationDelay: '-7.1s' }} />
          <path className="animate-flow-line-reverse" d="M -500 385 Q 250 351, 900 405"   stroke="url(#lineGradient2)" strokeWidth="1.3" fill="none" style={{ animationDuration: '24s', animationDelay: '-8.5s' }} />
          <path className="animate-flow-line"         d="M -500 290 Q 350 323, 900 272"   stroke="url(#lineGradient5)" strokeWidth="2.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-10.2s' }} />
          <path className="animate-flow-line-reverse" d="M -500 455 Q 140 421, 900 472"   stroke="url(#lineGradient9)" strokeWidth="1.4" fill="none" style={{ animationDuration: '27s', animationDelay: '-11.7s' }} />
          <path className="animate-flow-line"         d="M -500 325 Q 420 360, 900 308"   stroke="url(#lineGradient3)" strokeWidth="1.8" fill="none" style={{ animationDuration: '25s', animationDelay: '-13.0s' }} />
          <path className="animate-flow-line"         d="M -500 460 Q 310 493, 900 442"   stroke="url(#lineGradient7)" strokeWidth="1.6" fill="none" style={{ animationDuration: '28s', animationDelay: '-14.8s' }} />
          <path className="animate-flow-line-reverse" d="M -500 310 Q 230 277, 900 330"   stroke="url(#lineGradient6)" strokeWidth="2.1" fill="none" style={{ animationDuration: '24s', animationDelay: '-16.1s' }} />
          <path className="animate-flow-line"         d="M -500 415 Q 380 450, 900 398"   stroke="url(#lineGradient1)" strokeWidth="1.3" fill="none" style={{ animationDuration: '26s', animationDelay: '-17.6s' }} />
          <path className="animate-flow-line-reverse" d="M -500 280 Q 460 247, 900 300"   stroke="url(#lineGradient8)" strokeWidth="1.7" fill="none" style={{ animationDuration: '27s', animationDelay: '-19.2s' }} />
          <path className="animate-flow-line"         d="M -500 340 Q 160 375, 900 323"   stroke="url(#lineGradient4)" strokeWidth="2.1" fill="none" style={{ animationDuration: '25s', animationDelay: '-20.5s' }} />
          <path className="animate-flow-line-reverse" d="M -500 430 Q 270 397, 900 448"   stroke="url(#lineGradient2)" strokeWidth="1.3" fill="none" style={{ animationDuration: '28s', animationDelay: '-22.3s' }} />
          <path className="animate-flow-line"         d="M -500 365 Q 440 400, 900 348"   stroke="url(#lineGradient3)" strokeWidth="1.5" fill="none" style={{ animationDuration: '24s', animationDelay: '-23.7s' }} />
          <path className="animate-flow-line-reverse" d="M -500 295 Q 200 261, 900 315"   stroke="url(#lineGradient5)" strokeWidth="1.8" fill="none" style={{ animationDuration: '26s', animationDelay: '-25.4s' }} />
        </svg>
      </div>

      <div className="mx-auto max-w-7xl px-6 lg:px-8 relative z-10">
        <div className="mx-auto max-w-3xl text-center">
          {/* Open Source Badge */}
          <div className="mb-8 inline-flex items-center gap-2 px-4 py-2 rounded-full bg-gray-100/80 dark:bg-gray-800/80 backdrop-blur-sm">
            <svg className="w-4 h-4 text-gray-600 dark:text-gray-400" fill="currentColor" viewBox="0 0 16 16">
              <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/>
            </svg>
            <span className="text-sm font-medium text-gray-600 dark:text-gray-400">Open Source · Elastic License 2.0</span>
          </div>

          <h1 className="text-5xl font-bold tracking-tight text-gray-900 dark:text-white sm:text-7xl leading-tight">
            Speech to Text for Mac<br />at $0.02/hour
          </h1>

          <p className="mt-8 text-xl leading-relaxed text-gray-600 dark:text-gray-300 max-w-2xl mx-auto">
            Open source macOS menu bar app for live voice transcription.<br />
            Bring your own API key and pay only for what you use. No subscription.
          </p>

          <div className="mt-12 flex items-center justify-center gap-x-6">
            <Button
              variant="primary"
              size="lg"
              href="https://github.com/hazelguo/baseper/releases"
            >
              Download for macOS
            </Button>
            <a
              href="https://github.com/hazelguo/baseper"
              className="group relative inline-flex items-center justify-center rounded-lg p-[2.5px] text-lg font-medium transition-all focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-500"
            >
              <span className="absolute inset-0 rounded-lg animate-border-spin shadow-[0_0_15px_rgba(139,92,246,0.3)] group-hover:shadow-[0_0_25px_rgba(139,92,246,0.5)] transition-shadow duration-300" style={{ '--angle': '0deg' } as React.CSSProperties} />
              <span className="relative inline-flex items-center justify-center rounded-[5.5px] bg-white dark:bg-gray-900 px-8 py-4 text-gray-700 dark:text-gray-200 transition-colors group-hover:bg-gray-50 dark:group-hover:bg-gray-800">
                View on GitHub →
              </span>
            </a>
          </div>

          {/* BYOK emphasis */}
          <p className="mt-8 text-sm text-gray-500 dark:text-gray-500">
            Free and open source · No account needed · No data collected
          </p>
        </div>
      </div>
    </section>
  );
}

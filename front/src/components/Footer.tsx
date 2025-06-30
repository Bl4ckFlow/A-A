'use client';

export default function Footer() {
  return (
    <footer className="w-full bg-white/80 backdrop-blur-sm shadow-inner">
      <div className="max-w-7xl mx-auto px-6 py-6 flex flex-col md:flex-row items-center justify-between text-gray-700 text-sm">
        
        {/* Left side: copyright */}
        <div className="mb-2 md:mb-0">
          &copy; {new Date().getFullYear()} A&A. All rights reserved.
        </div>

        {/* Right side: navigation or links */}
        <div className="flex space-x-4">
          <a href="/about" className="hover:underline">About</a>
          <a href="/contact" className="hover:underline">Contact</a>
          <a href="/privacy" className="hover:underline">Privacy</a>
        </div>
      </div>
    </footer>
  );
}

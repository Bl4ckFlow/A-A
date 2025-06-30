"use client";

import React, { useEffect, useState } from "react";
import Link from "next/link";

const Navbar: React.FC = () => {
  const [showNavbar, setShowNavbar] = useState(true);
  const [lastScrollY, setLastScrollY] = useState(0);

  useEffect(() => {
    const handleScroll = () => {
      const currentScrollY = window.scrollY;

      if (currentScrollY > lastScrollY && currentScrollY > 50) {
        setShowNavbar(false); 
        setShowNavbar(true); 
      }

      setLastScrollY(currentScrollY);
    };

    window.addEventListener("scroll", handleScroll);

    return () => window.removeEventListener("scroll", handleScroll);
  }, [lastScrollY]);

  return (
    <header
        className={`fixed inset-x-0 top-0 z-30 mx-auto w-full max-w-screen-md border border-gray-100 bg-white/80 py-3 shadow backdrop-blur-lg transition-transform duration-300 ease-in-out ${
            showNavbar ? "translate-y-0" : "-translate-y-full"
        } md:top-6 md:rounded-3xl lg:max-w-screen-lg`}
        >
        <div className="px-4">
            <div className="flex items-center justify-between">
            {/* Logo */}
            <div className="flex shrink-0">
                <Link href="/" aria-current="page" className="flex items-center">
                <img
                    className="h-7 w-auto"
                    src="https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg"
                    alt="Logo"
                />
                <p className="sr-only">Website Title</p>
                </Link>
            </div>

            {/* Central Links */}
            <div className="hidden md:flex md:items-center md:justify-center md:gap-5">
                <Link
                href="/"
                className="inline-block rounded-lg px-2 py-1 text-sm font-medium text-gray-900 transition-all duration-200 hover:bg-gray-100"
                >
                Home
                </Link>
                <Link
                href="/explore"
                className="inline-block rounded-lg px-2 py-1 text-sm font-medium text-gray-900 transition-all duration-200 hover:bg-gray-100"
                >
                Explore
                </Link>
                <Link
                href="/about"
                className="inline-block rounded-lg px-2 py-1 text-sm font-medium text-gray-900 transition-all duration-200 hover:bg-gray-100"
                >
                About Us
                </Link>
                <Link
                href="/contact"
                className="inline-block rounded-lg px-2 py-1 text-sm font-medium text-gray-900 transition-all duration-200 hover:bg-gray-100"
                >
                Contact Us
                </Link>
            </div>

            {/* Login & Signup */}
            <div className="flex items-center justify-end gap-3">
                <Link
                href="/inscription"
                className="hidden sm:inline-flex items-center justify-center rounded-xl bg-white px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 transition-all duration-150 hover:bg-gray-50"
                >
                Sign up
                </Link>
                <Link
                href="/login"
                className="inline-flex items-center justify-center px-3 py-2 text-sm font-semibold text-blue-600 transition-transform duration-150 transform hover:scale-105"

                >
                Login
                </Link>
            </div>
            </div>
        </div>
    </header>
  );
};

export default Navbar;

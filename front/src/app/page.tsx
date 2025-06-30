'use client';

import { useState, useEffect } from 'react';
import Image from 'next/image';
import Navbar from '@/components/Navbar';
import Footer from '@/components/Footer';

const backgroundImages = ['/insc_bg.jpg', '/insc_bg2.jpg'];
const intervalTime = 5000; // 5 seconds

export default function Home() {
  const [currentIndex, setCurrentIndex] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentIndex((prevIndex) => (prevIndex + 1) % backgroundImages.length);
    }, intervalTime);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="flex flex-col min-h-screen font-[family-name:var(--font-geist-sans)] text-white">
      
      {/* Navbar */}
      <Navbar />

      {/* Hero Section */}
      <section className="relative h-screen w-full overflow-hidden">
        
        {/* Background Slider Images */}
        {backgroundImages.map((src, index) => (
          <Image
            key={index}
            src={src}
            alt={`Background ${index}`}
            fill
            className={`object-cover absolute inset-0 transition-opacity duration-1000 ${
              index === currentIndex ? 'opacity-100 z-0' : 'opacity-0'
            }`}
            priority={index === 0}
          />
        ))}

        {/* Dark Overlay */}
        <div className="absolute inset-0 bg-black/50 z-10" />

        {/* Hero Content */}
        <div className="relative z-20 flex flex-col items-center justify-center h-full text-center px-6">
          <h1 className="text-4xl sm:text-5xl font-bold mb-6">
            Join the <span className="text-blue-400">A&A</span> Family
          </h1>
          <p className="text-lg sm:text-xl mb-8 max-w-xl">
            Discover premium collections, exclusive offers, and unforgettable experiences.
          </p>
          <a
            href="/shop"
            className="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-3 rounded-lg shadow-lg transition-transform hover:scale-105 active:scale-95"
          >
            Start Shopping
          </a>
        </div>
      </section>

      {/* Best Sellers Section */}
      <section className="relative h-screen w-full bg-gray-100 text-gray-800 px-6 sm:px-12 py-16">
        <div className="absolute inset-0 flex flex-col justify-center items-center text-center overflow-y-auto">
          <h2 className="text-3xl sm:text-4xl font-bold mb-10">Our Best Sellers</h2>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl w-full px-2">
            {[1, 2, 3, 5, 4, 6].map((num, index) => (
              <div
                key={num}
                className="relative group rounded-xl overflow-hidden shadow-lg hover:shadow-2xl transition duration-300"
              >
                <img
                  src={`/products/${num}.jpg`}
                  alt={`Best Seller ${num}`}
                  className="w-full h-[500px] object-cover transition-transform duration-500 group-hover:scale-105"
                />

                {/* Hover overlay with name & stars */}
                <div className="absolute inset-0 bg-black bg-opacity-50 opacity-0 group-hover:opacity-80 transition-opacity duration-300 flex flex-col items-center justify-center text-white px-4">
                  <h3 className="text-xl font-semibold mb-2">
                    Product {index + 1} Name
                  </h3>
                  <div className="text-yellow-400 text-lg flex items-center gap-1">
                    ★ ★ ★ ★ ☆ <span className="text-white text-sm ml-2">(4.0)</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>




      {/* About Us Section */}
      <section className="w-full bg-white text-gray-800 px-6 sm:px-12 py-20 relative">
        {/* Title */}
        <div className="text-center mb-20">
          <h2 className="text-3xl sm:text-4xl font-bold">About Us</h2>
        </div>

        <div className="space-y-24 max-w-7xl mx-auto">
          {/* Row 1: Raouf + Company About */}
          <div className="flex flex-col md:flex-row gap-8 md:gap-12 items-center">
            {/* Left - Raouf */}
            <div className="flex flex-col items-center md:items-start text-center md:text-left w-full md:w-[45%]">
              <Image
                src="/r_pic.jpg"
                alt="Founder Abderraouf"
                width={300}
                height={300}
                className="rounded-lg object-cover shadow-lg mb-4"
              />
              <h3 className="text-xl font-semibold">LAARBI Abderraouf</h3>
              <p className="text-sm text-gray-600 mt-2 max-w-sm">
                Strategic and driven, Abderraouf ensures every step of the process reflects excellence — from production to delivery.
              </p>
            </div>

            {/* Vertical Divider */}
            <div className="hidden md:block w-px bg-gray-300 h-72"></div>

            {/* Right - Company About */}
            <div className="w-full md:w-[45%] text-center md:text-left">
              <h4 className="text-xl font-semibold mb-2">The Story Behind A&A</h4>
              <p className="text-base text-gray-700 leading-relaxed">
                A&A was born from the passion of two close friends who believed fashion should reflect individuality, elegance, and authenticity. From the ground up, every piece tells a story — one rooted in creativity, friendship, and purpose. Our mission is to design with heart, lead with style, and grow as a family.
              </p>
            </div>
          </div>

          {/* Row 2: Anes + Team Picture */}
          <div className="flex flex-col md:flex-row gap-8 md:gap-12 items-center">
            {/* Left - Anes */}
            <div className="flex flex-col items-center md:items-start text-center md:text-left w-full md:w-[45%]">
              <Image
                src="/a_pic.jpg"
                alt="Founder Anes"
                width={300}
                height={300}
                className="rounded-lg object-cover shadow-lg mb-4"
              />
              <h3 className="text-xl font-semibold">CHABIRA Anes</h3>
              <p className="text-sm text-gray-600 mt-2 max-w-sm">
                Visionary and deeply creative, Anes leads the aesthetic direction of A&A. From selecting fabrics to designing branding elements, his eye for detail brings soul to the style.
              </p>
            </div>


            {/* Vertical Divider */}
            <div className="hidden md:block w-px bg-gray-300 h-72"></div>

            {/* Right - Group Picture & Description */}
            <div className="w-full md:w-[45%] text-center md:text-left">
              <Image
                src="/products/1.jpg" // Replace later with actual group photo
                alt="Founders together"
                width={300}
                height={300}
                className="rounded-lg object-cover shadow-lg mb-4"
              />
              <p className="text-sm text-gray-600 max-w-md">
                A&A isn’t just a brand — it’s a bond. A vision nurtured by teamwork, late nights, and a shared love for design.
              </p>
            </div>
          </div>
        </div>

        {/* Quote at Bottom */}
        <div className="mt-24 text-center">
          <blockquote className="italic text-yellow-600 text-base sm:text-lg font-medium">
            “More than fashion — A&A is a family, a journey, and a shared expression of elegance.”
          </blockquote>
        </div>
      </section>






      {/* Main Content */}
      <main className="relative h-screen flex flex-col items-center justify-center px-6 py-16 bg-gray-100 text-gray-800">
        <h2 className="text-3xl font-bold mb-4">Why Choose A&A?</h2>
        <p className="max-w-2xl text-center text-lg text-gray-600 mb-8">
          We bring together elegance and quality to help you express your style. Join thousands who trust A&A for their fashion and lifestyle needs.
        </p>
        <a
          href="/inscription"
          className="bg-gray-900 hover:bg-gray-800 text-white font-medium px-6 py-3 rounded-lg"
        >
          Create an Account
        </a>
      </main>

      {/* Footer */}
      <Footer />
    </div>
  );
}

'use client';

import Image from 'next/image';
import Navbar from "@/components/Navbar";
import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const router = useRouter();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const res = await fetch('http://localhost:3750/api/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await res.json();

      if (!res.ok) {
        setError(data.error || 'Login failed');
        return;
      }

      // Redirect on success (e.g., to dashboard)
      router.push('/home'); // Change path if needed
    } catch (err) {
      console.error('Login error:', err);
      setError('An unexpected error occurred');
    }
  };

  return (
    <div className="relative min-h-screen w-full overflow-hidden">
      {/* Blurred Background */}
      <div className="absolute inset-0">
        <Image
          src="/insc_bg.jpg"
          alt="Background"
          fill
          className="object-cover blur-md brightness-50"
          priority
        />
      </div>

      <Navbar />

      {/* Centered Content */}
      <div className="relative flex min-h-screen items-center justify-center px-4 py-8 z-10">
        <div className="flex w-full max-w-4xl flex-col md:flex-row overflow-hidden rounded-3xl shadow-2xl bg-white/80 backdrop-blur-lg min-h-[500px]">
          
          {/* Left: Form */}
          <div className="w-full md:w-1/2 p-8 md:p-12 flex flex-col justify-center">
            <h2 className="mb-6 text-2xl font-bold text-gray-900">Login to Your Account</h2>
            <form className="space-y-4" onSubmit={handleLogin}>
              {/* Email */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Email</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                />
              </div>

              {/* Password */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Password</label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                />
              </div>

              {/* Error message */}
              {error && (
                <div className="text-red-600 text-sm">{error}</div>
              )}

              {/* Submit button */}
              <button
                type="submit"
                className="w-full rounded-lg bg-blue-600 px-4 py-2 text-white font-semibold transition-transform duration-150 transform hover:scale-105 active:scale-95"
              >
                Login
              </button>

              {/* Register link */}
              <div className="flex justify-between w-full text-md mt-4">
                <p className="text-black">Don't have an account yet?</p>
                <a href="/inscription" className="text-blue-600 hover:underline">Join us</a>
              </div>
            </form>
          </div>

          {/* Right: Image */}
          <div className="hidden md:block w-1/2 relative">
            <Image
              src="/insc_bg.jpg"
              alt="Side Image"
              fill
              className="object-cover"
            />
          </div>
        </div>
      </div>
    </div>
  );
}

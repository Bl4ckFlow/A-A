'use client';

import Image from 'next/image';
import Navbar from "@/components/Navbar";       

export default function InscriptionPage() {
  return (
    <div className="relative min-h-screen w-full overflow-hidden">
      {/* Blurred Full Background */}
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
        <div className="flex w-full max-w-4xl flex-col md:flex-row overflow-hidden rounded-3xl shadow-2xl bg-white/80 backdrop-blur-lg min-h-[700px]">
          
          {/* Left: Form */}
          <div className="w-full md:w-1/2 p-8 md:p-12">
            <h2 className="mb-6 text-2xl font-bold text-gray-900">Create an Account</h2>
            <form className="space-y-4">
              
              {/* First Name & Last Name */}
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">First Name</label>
                  <input
                    type="text"
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  />
                </div>
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Last Name</label>
                  <input
                    type="text"
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  />
                </div>
              </div>

              {/* Email */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Email</label>
                <input
                  type="email"
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                />
              </div>

              {/* Gender & Birth Date */}
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Gender</label>
                  <select
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                    defaultValue=""
                  >
                    <option value="" disabled className='text-gray-700'>Select gender</option>
                    <option>Male</option>
                    <option>Female</option>
                  </select>
                </div>
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Birth Date</label>
                  <input
                    type="date"
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  />
                </div>
              </div>

              {/* Phone Number */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Phone Number</label>
                <input
                  type="tel"
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  placeholder="+1234567890"
                />
              </div>

              {/* Password */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Password</label>
                <input
                  type="password"
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                />
              </div>

              {/* Submit button */}
              <button
                type="submit"
                className="w-full rounded-lg bg-blue-600 px-4 py-2 text-white font-semibold transition-transform duration-150 transform hover:scale-105 active:scale-95"
              >
                Sign Up
              </button>

              {/* Login link */}
              <div className="flex justify-between w-full text-md mt-4">
                <p className="text-black">Already have an account?</p>
                <a href="/login" className="text-blue-600 hover:underline">Login Now</a>
              </div>
            </form>
          </div>

          {/* Right: Image (non-blurred) */}
          <div className="hidden md:block w-1/2 relative">
            <Image
              src="/insc_bg2.jpg"
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

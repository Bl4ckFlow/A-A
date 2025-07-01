'use client';

import React, { useState } from 'react';
import Image from 'next/image';
import Navbar from "@/components/Navbar";

export default function InscriptionPage() {
  // State hooks to store form data
  const [firstName, setFirstName] = useState('');
  const [lastName, setLastName] = useState('');
  const [email, setEmail] = useState('');
  const [gender, setGender] = useState('');
  const [birthDate, setBirthDate] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');

  const handleSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();

    // Prepare data to send
    const data = {
      first_name: firstName,
      last_name: lastName,
      email,
      gender,
      birthdate: birthDate,
      phone,
      password,
    };

    try {
      const res = await fetch('http://localhost:3750/api/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
      });

      if (!res.ok) {
        // handle errors from server
        const errorData = await res.json();
        alert(`Error: ${errorData.error || 'Something went wrong'}`);
        return;
      }

      alert('User created successfully!');
      // Optionally redirect or clear form here

    } catch (error) {
      console.error('Submit error:', error);
      alert('Failed to create user');
    }
  };

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
            <form className="space-y-4" onSubmit={handleSubmit}>

              {/* First Name & Last Name */}
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">First Name</label>
                  <input
                    type="text"
                    value={firstName}
                    onChange={(e) => setFirstName(e.target.value)}
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                    required
                  />
                </div>
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Last Name</label>
                  <input
                    type="text"
                    value={lastName}
                    onChange={(e) => setLastName(e.target.value)}
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                    required
                  />
                </div>
              </div>

              {/* Email */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Email</label>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  required
                />
              </div>

              {/* Gender & Birth Date */}
              <div className="flex flex-col md:flex-row gap-4">
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Gender</label>
                  <select
                    value={gender}
                    onChange={(e) => setGender(e.target.value)}
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                    required
                  >
                    <option value="" disabled className='text-gray-700'>Select gender</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                  </select>
                </div>
                <div className="flex-1">
                  <label className="block text-sm font-medium text-gray-700">Birth Date</label>
                  <input
                    type="date"
                    value={birthDate}
                    onChange={(e) => setBirthDate(e.target.value)}
                    className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                    required
                  />
                </div>
              </div>

              {/* Phone Number */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Phone Number</label>
                <input
                  type="tel"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  placeholder="+1234567890"
                  required
                />
              </div>

              {/* Password */}
              <div>
                <label className="block text-sm font-medium text-gray-700">Password</label>
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="mt-1 w-full rounded-lg border border-gray-400 px-4 py-2 text-sm shadow-sm focus:border-gray-800 focus:outline-none text-black"
                  required
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

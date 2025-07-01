"use client";

import React from "react";

const sections = [
  "User Info",
  "Address",
  "Security",
  "Orders",
  "Cart",
  "Billing",
];

// Define the props type
interface SideNavProps {
  activeSection: string;
  setActiveSection: React.Dispatch<React.SetStateAction<string>>;
}

export default function SideNav({ activeSection, setActiveSection }: SideNavProps) {
  return (
    <nav className="w-64 bg-white border-r border-gray-200 min-h-screen p-6 flex flex-col">
      <h1 className="mb-8 text-2xl font-bold text-gray-900">Profile</h1>
      {sections.map((section) => (
        <button
          key={section}
          onClick={() => setActiveSection(section)}
          className={`mb-3 rounded px-4 py-2 text-left text-gray-700 hover:bg-gray-100 focus:outline-none ${
            activeSection === section ? "bg-gray-200 font-semibold" : ""
          }`}
        >
          {section}
        </button>
      ))}
    </nav>
  );
}

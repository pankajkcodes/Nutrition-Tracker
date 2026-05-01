import React from 'react';
import { Link } from 'react-router-dom';
import { Activity, ArrowLeft, Heart, Shield, Users } from 'lucide-react';

export default function AboutUs() {
  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100 font-sans selection:bg-green-500 selection:text-white pb-20">
      {/* Header */}
      <header className="w-full border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-950 sticky top-0 z-50">
        <div className="max-w-4xl mx-auto px-6 h-16 flex items-center justify-between">
          <Link to="/" className="flex items-center gap-2 hover:opacity-80 transition-opacity">
            <ArrowLeft className="w-5 h-5 text-gray-500 dark:text-gray-400" />
            <span className="font-medium">Back to Home</span>
          </Link>
          <div className="flex items-center gap-2">
            <Activity className="text-green-500 w-6 h-6" />
            <span className="font-bold text-lg text-gray-900 dark:text-white">NutritionTracker</span>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800 py-20 px-6 text-center">
        <div className="max-w-3xl mx-auto">
          <h1 className="text-5xl font-extrabold tracking-tight mb-6">About Us</h1>
          <p className="text-xl text-gray-600 dark:text-gray-400 leading-relaxed">
            We are on a mission to make healthy living accessible, intuitive, and sustainable for everyone.
          </p>
        </div>
      </section>

      {/* Content */}
      <main className="max-w-4xl mx-auto px-6 pt-16">
        <div className="grid md:grid-cols-3 gap-8 mb-16">
          <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm text-center">
            <div className="w-12 h-12 bg-green-50 dark:bg-green-500/10 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <Heart className="w-6 h-6 text-green-600 dark:text-green-400" />
            </div>
            <h3 className="font-bold text-lg mb-2">Our Passion</h3>
            <p className="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">We care deeply about well-being and empowering individuals to take control of their health journeys.</p>
          </div>
          <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm text-center">
            <div className="w-12 h-12 bg-green-50 dark:bg-green-500/10 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <Users className="w-6 h-6 text-green-600 dark:text-green-400" />
            </div>
            <h3 className="font-bold text-lg mb-2">Our Community</h3>
            <p className="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">Built for people of all fitness levels. We believe in inclusive design and straightforward tools.</p>
          </div>
          <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm text-center">
            <div className="w-12 h-12 bg-green-50 dark:bg-green-500/10 rounded-2xl flex items-center justify-center mx-auto mb-4">
              <Shield className="w-6 h-6 text-green-600 dark:text-green-400" />
            </div>
            <h3 className="font-bold text-lg mb-2">Our Commitment</h3>
            <p className="text-gray-600 dark:text-gray-400 text-sm leading-relaxed">Your privacy is our priority. We never sell your personal data to third parties.</p>
          </div>
        </div>

        <div className="prose prose-green dark:prose-invert max-w-none prose-lg text-gray-600 dark:text-gray-400">
          <h2 className="text-gray-900 dark:text-gray-100 font-bold text-3xl mb-6">Our Story</h2>
          <p>
            NutritionTracker started as a simple idea: tracking what you eat shouldn't feel like a chore. Too many apps are cluttered with ads, overly complex features, or confusing interfaces.
          </p>
          <p>
            We set out to build a streamlined, highly personalized experience that focuses on what actually matters—helping you hit your caloric, macronutrient, and hydration goals consistently. By simplifying the process, we help you build sustainable habits that last a lifetime.
          </p>
        </div>
      </main>
    </div>
  );
}

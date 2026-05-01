import React from 'react';
import { Link } from 'react-router-dom';
import { Activity, ArrowLeft } from 'lucide-react';

export default function PrivacyPolicy() {
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

      {/* Content */}
      <main className="max-w-4xl mx-auto px-6 pt-12">
        <h1 className="text-4xl font-extrabold tracking-tight mb-8">Privacy Policy</h1>
        <div className="prose prose-green dark:prose-invert max-w-none prose-lg text-gray-600 dark:text-gray-400">
          <p>Last updated: {new Date().toLocaleDateString()}</p>
          
          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">1. Information We Collect</h2>
          <p>
            When you use NutritionTracker, we may collect personal information such as your name, email address, and physical characteristics (e.g., age, weight, height) to provide personalized nutritional goals. We also collect usage data to improve our services.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">2. How We Use Your Information</h2>
          <p>
            The information we collect is used to:
          </p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Provide, operate, and maintain our application.</li>
            <li>Calculate personalized daily calorie and macronutrient goals.</li>
            <li>Improve, personalize, and expand our application's features.</li>
            <li>Understand and analyze how you use our application.</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">3. Data Security</h2>
          <p>
            We prioritize the security of your personal information. We implement commercially reasonable security measures to protect against unauthorized access, alteration, disclosure, or destruction of your personal information, username, password, transaction information, and data stored on our app.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">4. Changes to This Privacy Policy</h2>
          <p>
            We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">5. Contact Us</h2>
          <p>
            If you have any questions about this Privacy Policy, please contact us at privacy@nutritiontracker.app.
          </p>
        </div>
      </main>
    </div>
  );
}

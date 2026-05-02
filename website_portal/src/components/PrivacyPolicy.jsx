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
                    <p>Last updated: {new Date().toLocaleDateString('en-US', { day: 'numeric', month: 'long', year: 'numeric' })}</p>
          <p>
            Welcome to Nutrition Tracker ("we", "our", or "us"). Your privacy is important to us. This Privacy Policy explains how we collect, use, store, and protect your information when you use our mobile application.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">1. Information We Collect</h2>
          <p>We may collect the following types of information:</p>
          
          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">a. Personal Information</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Name</li>
            <li>Email address</li>
          </ul>

          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">b. Usage Data</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>App usage activity</li>
            <li>Features accessed</li>
            <li>Device information (device type, OS version)</li>
          </ul>

          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">c. Nutrition Data</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Food intake</li>
            <li>Calorie tracking</li>
            <li>Health-related inputs provided by you</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">2. How We Use Your Information</h2>
          <p>We use your information to:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Provide and maintain the app</li>
            <li>Calculate personalized nutrition goals</li>
            <li>Improve app performance and user experience</li>
            <li>Communicate updates or important information</li>
            <li>Analyze usage to enhance features</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">3. Data Sharing and Disclosure</h2>
          <p>
            We <strong>do not sell, trade, or rent your personal data</strong> to third parties.
          </p>
          <p>We may share data only in the following cases:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>With service providers (e.g., hosting, analytics) strictly for app functionality</li>
            <li>If required by law or legal process</li>
            <li>To protect our legal rights</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">4. Data Retention and Deletion</h2>
          
          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">Data Retention</h3>
          <p>We retain your personal data only as long as necessary:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Data is stored while your account is active</li>
            <li>If you stop using the app, data may be retained for up to <strong>90 days</strong> for backup and legal purposes</li>
          </ul>

          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">Data Deletion</h3>
          <p>You have full control over your data:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>You can delete your account from within the app (if available), OR</li>
            <li>You can request deletion by contacting us at: <a href="mailto:privacy@nutritiontracker.app" className="text-green-500 hover:underline">privacy@nutritiontracker.app</a></li>
          </ul>
          <p>After receiving a deletion request:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Your data will be permanently deleted within <strong>7–15 working days</strong></li>
            <li>Some data may be retained if required by law or security purposes</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">5. Data Security</h2>
          <p>
            We implement reasonable security measures to protect your data from unauthorized access, alteration, or disclosure.
          </p>
          <p>
            However, no method of transmission over the internet is 100% secure.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">6. Your Rights</h2>
          <p>You have the right to:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Access your data</li>
            <li>Update or correct your data</li>
            <li>Request deletion of your data</li>
            <li>Withdraw consent at any time</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">7. Children’s Privacy</h2>
          <p>
            Our app is not intended for children under 13. We do not knowingly collect data from children.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">8. Changes to This Privacy Policy</h2>
          <p>
            We may update this Privacy Policy from time to time. We will notify users by updating the "Last updated" date.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">9. Contact Us</h2>
          <p>
            If you have any questions or requests regarding this Privacy Policy, contact us at:
          </p>
          <p className="flex items-center gap-2">
            <span>📧</span>
            <a href="mailto:sdepankaj@gmail.com" className="text-green-500 hover:underline">sdepankaj@gmail.com</a>
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">10. Consent</h2>
          <p>
            By using our app, you agree to this Privacy Policy and the collection and use of information in accordance with it.
          </p>
        </div>
      </main>
    </div>
  );
}

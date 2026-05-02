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
                              <p>Last updated: April 28, 2026</p>
          <p>
            Nutrition Tracker (“we”, “our”, or “us”) values your privacy. This Privacy Policy explains how we collect, use, store, and protect your information when you use our mobile application.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">1. Information We Collect</h2>
          <p>We may collect the following types of information:</p>
          
          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">a. Personal Information</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Name</li>
            <li>Email address</li>
          </ul>

          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">b. Health & Nutrition Data</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Age, weight, height</li>
            <li>Calorie intake and food tracking data</li>
          </ul>

          <h3 className="text-gray-900 dark:text-gray-100 font-bold mt-6 mb-2 text-xl">c. Device & Usage Data</h3>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Device type, operating system</li>
            <li>App usage behavior and interactions</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">2. How We Use Your Information</h2>
          <p>We use your information to:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Provide and maintain app functionality</li>
            <li>Calculate personalized nutrition and calorie goals</li>
            <li>Improve user experience and app performance</li>
            <li>Analyze usage for app improvements</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">3. Data Sharing</h2>
          <p>We do not sell your personal data.</p>
          <p>We may share your data with:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Service providers (such as Firebase for analytics, authentication, and storage)</li>
            <li>Legal authorities if required by law</li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">4. Data Security</h2>
          <p>
            We use reasonable security measures to protect your data. However, no method of transmission or storage is 100% secure.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">5. Data Retention</h2>
          <p>We retain your data only as long as necessary:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Account data is stored while your account is active</li>
            <li>Nutrition and usage data are stored to provide app services</li>
            <li>After account deletion, data may be retained for up to <strong>30 days</strong> for backup and security purposes</li>
          </ul>
          <p className="mt-4">
            After this period, your data is permanently deleted or anonymized.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">6. Data Deletion & User Rights</h2>
          <p>You have the right to request deletion of your personal data at any time.</p>
          <p>You can request deletion by:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Using the Delete Account option inside the app, OR</li>
            <li>Sending an email to: <a href="mailto:sdepankaj@gmail.com" className="text-green-500 hover:underline">sdepankaj@gmail.com</a>, OR</li>
            <li>
              Visiting:<br/>
              👉 <Link to="/delete-account" className="text-green-500 hover:underline font-bold">https://nutrition-trackerapp.web.app/delete-account</Link>
            </li>
          </ul>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">7. Account Deletion</h2>
          <p>When you request account deletion:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Your request will be processed within <strong>7–30 days</strong></li>
            <li>Your account and all associated data will be permanently deleted</li>
          </ul>
          <p className="mt-4 font-semibold">This includes:</p>
          <ul className="list-disc pl-6 space-y-1 mt-2">
            <li>Personal information</li>
            <li>Nutrition tracking data</li>
            <li>Usage history</li>
          </ul>
          <p className="mt-4">
            Some data may be retained if required by law or for security purposes.
          </p>
          <p className="mt-2 text-red-500 font-bold">
            Once deleted, your data cannot be recovered.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">8. Children’s Privacy</h2>
          <p>
            This app is not intended for children under the age of 13. We do not knowingly collect personal data from children.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">9. Third-Party Services</h2>
          <p>We may use trusted third-party services such as:</p>
          <ul className="list-disc pl-6 space-y-2 mt-2">
            <li>Firebase Analytics</li>
            <li>Firebase Authentication</li>
            <li>Cloud Storage</li>
          </ul>
          <p className="mt-4 text-sm italic text-gray-500">
            These services may process your data according to their own privacy policies.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">10. Changes to This Privacy Policy</h2>
          <p>
            We may update this Privacy Policy from time to time. Updates will be posted on this page with a revised date.
          </p>

          <h2 className="text-gray-900 dark:text-gray-100 font-bold mt-10 mb-4 text-2xl">11. Contact Us</h2>
          <p>
            If you have any questions or requests regarding this Privacy Policy, contact us:
          </p>
          <p className="flex items-center gap-2 font-medium">
            <span>📧</span>
            <a href="mailto:sdepankaj@gmail.com" className="text-green-500 hover:underline">sdepankaj@gmail.com</a>
          </p>
        </div>
      </main>
    </div>
  );
}

import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { db } from '../firebase/config';
import { collection, addDoc, serverTimestamp, query, where, getDocs } from 'firebase/firestore';
import { Activity, ArrowLeft, Send, CheckCircle2, AlertCircle } from 'lucide-react';

export default function DeleteAccount() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    reason: ''
  });
  const [status, setStatus] = useState('idle'); // idle, submitting, success, error
  const [errorMessage, setErrorMessage] = useState('');

  const handleSubmit = async (e) => {
    e.preventDefault();
    setStatus('submitting');

    try {
      // 1. Check if user exists in 'users' collection
      const usersRef = collection(db, 'users');
      // Note: We check both email and fullName to ensure a precise match
      const q = query(
        usersRef, 
        where('email', '==', formData.email.trim().toLowerCase()),
        where('fullName', '==', formData.name.trim())
      );
      
      const querySnapshot = await getDocs(q);

      if (querySnapshot.empty) {
        setStatus('error');
        setErrorMessage('We couldn\'t find an account matching these details. Please double-check your name and email.');
        return;
      }

      // 2. If user exists, save to 'deletion_requests'
      const userDoc = querySnapshot.docs[0];
      await addDoc(collection(db, 'deletion_requests'), {
        ...formData,
        uid: userDoc.id, // Include the UID for easier processing
        submittedAt: serverTimestamp(),
        status: 'pending'
      });
      
      setStatus('success');
      setFormData({ name: '', email: '', reason: '' });
    } catch (error) {
      console.error('Error submitting deletion request:', error);
      setStatus('error');
      setErrorMessage('Something went wrong. Please try again later or contact support.');
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 dark:bg-gray-950 text-gray-900 dark:text-gray-100 font-sans selection:bg-red-500 selection:text-white pb-20">
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
      <main className="max-w-2xl mx-auto px-6 pt-16">
        <div className="text-center mb-12">
          <h1 className="text-4xl font-extrabold tracking-tight mb-4 text-gray-900 dark:text-white">
            Delete Your Account
          </h1>
          <p className="text-lg text-gray-600 dark:text-gray-400">
            We're sorry to see you go. Please let us know why you'd like to delete your account so we can improve.
          </p>
        </div>

        {status === 'success' ? (
          <div className="bg-white dark:bg-gray-900 rounded-3xl p-8 shadow-xl border border-green-100 dark:border-green-900/30 text-center animate-in fade-in zoom-in duration-300">
            <div className="w-20 h-20 bg-green-50 dark:bg-green-500/10 rounded-full flex items-center justify-center mx-auto mb-6">
              <CheckCircle2 className="w-10 h-10 text-green-500" />
            </div>
            <h2 className="text-2xl font-bold mb-2">Request Received</h2>
            <p className="text-gray-600 dark:text-gray-400 mb-8">
              Your account deletion request has been submitted. Our team will process it within 7-15 working days.
            </p>
            <Link 
              to="/" 
              className="inline-flex items-center justify-center px-8 py-3 bg-green-500 hover:bg-green-600 text-white font-bold rounded-xl transition-all hover:scale-105 active:scale-95"
            >
              Return Home
            </Link>
          </div>
        ) : (
          <div className="bg-white dark:bg-gray-900 rounded-3xl p-8 shadow-xl border border-gray-100 dark:border-gray-800">
            <form onSubmit={handleSubmit} className="space-y-6">
              <div>
                <label className="block text-sm font-semibold mb-2 ml-1 text-gray-700 dark:text-gray-300">
                  Full Name
                </label>
                <input
                  required
                  type="text"
                  placeholder="John Doe"
                  className="w-full px-5 py-3 rounded-xl bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500/50 transition-all text-gray-900 dark:text-white"
                  value={formData.name}
                  onChange={(e) => setFormData({ ...formData, name: e.target.value })}
                  disabled={status === 'submitting'}
                />
              </div>

              <div>
                <label className="block text-sm font-semibold mb-2 ml-1 text-gray-700 dark:text-gray-300">
                  Email Address
                </label>
                <input
                  required
                  type="email"
                  placeholder="john@example.com"
                  className="w-full px-5 py-3 rounded-xl bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500/50 transition-all text-gray-900 dark:text-white"
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  disabled={status === 'submitting'}
                />
              </div>

              <div>
                <label className="block text-sm font-semibold mb-2 ml-1 text-gray-700 dark:text-gray-300">
                  Reason for Deletion (Optional)
                </label>
                <textarea
                  rows="4"
                  placeholder="Tell us why you are leaving..."
                  className="w-full px-5 py-3 rounded-xl bg-gray-50 dark:bg-gray-800 border border-gray-200 dark:border-gray-700 focus:outline-none focus:ring-2 focus:ring-green-500/50 transition-all text-gray-900 dark:text-white resize-none"
                  value={formData.reason}
                  onChange={(e) => setFormData({ ...formData, reason: e.target.value })}
                  disabled={status === 'submitting'}
                />
              </div>

              {status === 'error' && (
                <div className="flex items-center gap-3 p-4 bg-red-50 dark:bg-red-900/20 text-red-600 dark:text-red-400 rounded-xl text-sm border border-red-100 dark:border-red-900/30">
                  <AlertCircle className="w-5 h-5 flex-shrink-0" />
                  <p>{errorMessage}</p>
                </div>
              )}

              <button
                type="submit"
                disabled={status === 'submitting'}
                className="w-full flex items-center justify-center gap-2 py-4 bg-gray-900 dark:bg-green-500 hover:bg-gray-800 dark:hover:bg-green-600 text-white font-bold rounded-xl transition-all hover:scale-[1.02] active:scale-[0.98] disabled:opacity-50 disabled:hover:scale-100"
              >
                {status === 'submitting' ? (
                  <div className="w-6 h-6 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                ) : (
                  <>
                    <Send className="w-5 h-5" />
                    Submit Deletion Request
                  </>
                )}
              </button>

              <p className="text-center text-xs text-gray-500 dark:text-gray-500 pt-2 px-4">
                By submitting this request, you acknowledge that your data will be permanently removed from our servers within the specified timeframe.
              </p>
            </form>
          </div>
        )}
      </main>
    </div>
  );
}

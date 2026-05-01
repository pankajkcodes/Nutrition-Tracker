import React from 'react';

export default function Dashboard() {
  return (
    <div className="space-y-6">
      <h2 className="text-3xl font-bold text-gray-900 dark:text-white">Dashboard</h2>
      <p className="text-gray-600 dark:text-gray-400">
        Welcome to the Nutrition Tracker Admin Panel. Use the sidebar to manage your app's data.
      </p>
      
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">Food Library</h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">Manage the global database of food items available to all users.</p>
          <a href="/food-library" className="text-blue-600 dark:text-blue-400 hover:underline font-medium text-sm">Manage Items &rarr;</a>
        </div>
        
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-100 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-2">Users</h3>
          <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">View registered users, their profiles, and their daily logs.</p>
          <a href="/users" className="text-blue-600 dark:text-blue-400 hover:underline font-medium text-sm">View Users &rarr;</a>
        </div>
      </div>
    </div>
  );
}

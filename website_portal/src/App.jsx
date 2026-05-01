import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { auth } from './firebase/config';
import { onAuthStateChanged, signOut } from 'firebase/auth';
import Auth from './components/Auth';
import Dashboard from './components/Dashboard';
import FoodLibraryManager from './components/FoodLibraryManager';
import UserManager from './components/UserManager';
import { LogOut, LayoutDashboard, Utensils, Users } from 'lucide-react';
import { Link, useLocation } from 'react-router-dom';
import LandingPage from './components/LandingPage';
import PrivacyPolicy from './components/PrivacyPolicy';
import AboutUs from './components/AboutUs';

function Layout({ children }) {
  const location = useLocation();

  const handleLogout = async () => {
    await signOut(auth);
  };

  const navItems = [
    { name: 'Dashboard', path: '/secure_admin_portal', icon: LayoutDashboard },
    { name: 'Food Library', path: '/secure_admin_portal/food-library', icon: Utensils },
    { name: 'Users', path: '/secure_admin_portal/users', icon: Users },
  ];

  return (
    <div className="flex h-screen bg-gray-50 dark:bg-gray-900">
      <aside className="w-64 bg-white dark:bg-gray-800 border-r border-gray-200 dark:border-gray-700 flex flex-col">
        <div className="p-6">
          <h1 className="text-2xl font-bold text-gray-900 dark:text-white">Admin Panel</h1>
          <p className="text-sm text-gray-500 dark:text-gray-400">Nutrition Tracker</p>
        </div>
        <nav className="flex-1 px-4 space-y-2">
          {navItems.map((item) => {
            const Icon = item.icon;
            const isActive = location.pathname === item.path;
            return (
              <Link
                key={item.name}
                to={item.path}
                className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                  isActive 
                    ? 'bg-blue-50 text-blue-700 dark:bg-blue-900/50 dark:text-blue-200 font-medium' 
                    : 'text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700'
                }`}
              >
                <Icon size={20} />
                {item.name}
              </Link>
            );
          })}
        </nav>
        <div className="p-4 border-t border-gray-200 dark:border-gray-700">
          <button
            onClick={handleLogout}
            className="flex items-center gap-3 px-4 py-3 w-full rounded-lg text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors"
          >
            <LogOut size={20} />
            Logout
          </button>
        </div>
      </aside>
      <main className="flex-1 overflow-auto p-8">
        {children}
      </main>
    </div>
  );
}

function AdminRoute({ children, user }) {
  if (!user) {
    return <Auth />;
  }
  return <Layout>{children}</Layout>;
}

function App() {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsubscribe = onAuthStateChanged(auth, (currentUser) => {
      setUser(currentUser);
      setLoading(false);
    });
    return unsubscribe;
  }, []);

  if (loading) {
    return <div className="flex h-screen items-center justify-center dark:bg-gray-900 dark:text-white">Loading...</div>;
  }

  return (
    <Router>
      <Routes>
        <Route path="/" element={<LandingPage />} />
        <Route path="/privacy" element={<PrivacyPolicy />} />
        <Route path="/about" element={<AboutUs />} />
        
        {/* Secure Admin Routes */}
        <Route path="/secure_admin_portal" element={<AdminRoute user={user}><Dashboard /></AdminRoute>} />
        <Route path="/secure_admin_portal/food-library" element={<AdminRoute user={user}><FoodLibraryManager /></AdminRoute>} />
        <Route path="/secure_admin_portal/users" element={<AdminRoute user={user}><UserManager /></AdminRoute>} />
        
        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </Router>
  );
}

export default App;

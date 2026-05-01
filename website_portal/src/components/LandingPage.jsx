import React from 'react';
import { Link } from 'react-router-dom';
import { Activity, Apple, Droplets, Target, ArrowRight, CheckCircle2 } from 'lucide-react';

export default function LandingPage() {
  return (
    <div className="min-h-screen bg-white dark:bg-gray-950 text-gray-900 dark:text-gray-100 font-sans selection:bg-green-500 selection:text-white">
      {/* Navigation */}
      <nav className="fixed w-full z-50 top-0 border-b border-gray-100 dark:border-gray-800 bg-white/80 dark:bg-gray-950/80 backdrop-blur-md">
        <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-lg bg-gradient-to-br from-green-400 to-emerald-600 flex items-center justify-center">
              <Activity className="text-white w-5 h-5" />
            </div>
            <span className="font-bold text-xl tracking-tight text-gray-900 dark:text-white">
              NutritionTracker
            </span>
          </div>
          <div className="flex items-center gap-4">
            <a href="#features" className="text-sm font-medium text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white transition-colors">
              Features
            </a>
            <a href="#testimonials" className="text-sm font-medium text-gray-600 hover:text-gray-900 dark:text-gray-300 dark:hover:text-white transition-colors">
              Testimonials
            </a>
            <button className="px-4 py-2 text-sm font-medium text-white bg-gray-900 hover:bg-gray-800 dark:bg-white dark:text-gray-900 dark:hover:bg-gray-100 rounded-full transition-all active:scale-95 shadow-sm">
              Get the App
            </button>
          </div>
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative pt-32 pb-20 lg:pt-48 lg:pb-32 overflow-hidden flex flex-col items-center justify-center text-center px-6">
        {/* Abstract Background Gradients */}
        <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[600px] bg-green-500/20 dark:bg-green-500/10 blur-[120px] rounded-full pointer-events-none" />
        <div className="absolute top-1/3 left-1/4 -translate-x-1/2 w-[400px] h-[400px] bg-emerald-400/20 dark:bg-emerald-400/10 blur-[100px] rounded-full pointer-events-none" />
        
        <div className="relative max-w-4xl mx-auto flex flex-col items-center">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-green-50 dark:bg-green-500/10 border border-green-200 dark:border-green-500/20 text-green-700 dark:text-green-400 text-sm font-medium mb-8 animate-fade-in-up">
            <span className="flex h-2 w-2 relative">
              <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-green-500 opacity-75"></span>
              <span className="relative inline-flex rounded-full h-2 w-2 bg-green-600"></span>
            </span>
            New version available now
          </div>
          
          <h1 className="text-5xl lg:text-7xl font-extrabold tracking-tight text-gray-900 dark:text-white mb-6 animate-fade-in-up animation-delay-100">
            Master your health, <br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-green-500 to-emerald-600">
              one meal at a time.
            </span>
          </h1>
          
          <p className="text-lg text-gray-600 dark:text-gray-400 mb-10 max-w-2xl leading-relaxed animate-fade-in-up animation-delay-200">
            Track your calories, monitor macronutrients, and stay hydrated with our highly intuitive and personalized mobile tracking app. Build sustainable habits that last a lifetime.
          </p>
          
          <div className="flex flex-col sm:flex-row items-center gap-4 animate-fade-in-up animation-delay-300">
            <button className="flex items-center gap-2 px-8 py-4 text-base font-semibold text-white bg-green-600 hover:bg-green-700 rounded-full transition-all hover:shadow-lg hover:shadow-green-500/25 active:scale-95">
              Download App
              <ArrowRight className="w-5 h-5" />
            </button>
            <button className="flex items-center gap-2 px-8 py-4 text-base font-semibold text-gray-700 dark:text-gray-300 bg-gray-100 hover:bg-gray-200 dark:bg-gray-800 dark:hover:bg-gray-700 rounded-full transition-all active:scale-95">
              Learn More
            </button>
          </div>
        </div>
        
        {/* Dashboard Preview Mockup */}
        <div className="mt-20 relative max-w-5xl mx-auto w-full animate-fade-in-up animation-delay-400">
          <div className="aspect-[16/9] md:aspect-[21/9] rounded-2xl md:rounded-[2rem] overflow-hidden bg-gradient-to-b from-gray-50 to-gray-100 dark:from-gray-800 dark:to-gray-900 border border-gray-200 dark:border-gray-800 shadow-2xl relative">
             <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1490645935967-10de6ba17061?q=80&w=2053&auto=format&fit=crop')] bg-cover bg-center opacity-40 mix-blend-overlay dark:opacity-20"></div>
             <div className="absolute inset-0 flex items-center justify-center p-8">
               <div className="bg-white/80 dark:bg-gray-950/80 backdrop-blur-xl rounded-2xl border border-gray-200/50 dark:border-gray-800/50 p-8 w-full max-w-3xl shadow-xl flex gap-8 flex-col md:flex-row">
                 <div className="flex-1 space-y-4">
                    <div className="h-4 w-1/3 bg-gray-200 dark:bg-gray-800 rounded-full"></div>
                    <div className="h-10 w-3/4 bg-gradient-to-r from-green-500/20 to-emerald-500/20 rounded-lg"></div>
                    <div className="space-y-2 mt-8">
                      <div className="h-3 w-full bg-gray-200 dark:bg-gray-800 rounded-full"></div>
                      <div className="h-3 w-5/6 bg-gray-200 dark:bg-gray-800 rounded-full"></div>
                      <div className="h-3 w-4/6 bg-gray-200 dark:bg-gray-800 rounded-full"></div>
                    </div>
                 </div>
                 <div className="w-32 h-32 rounded-full border-8 border-green-100 dark:border-gray-800 flex items-center justify-center flex-shrink-0 relative">
                    <div className="absolute inset-0 rounded-full border-8 border-green-500 border-t-transparent -rotate-45"></div>
                    <div className="text-xl font-bold">1,840</div>
                 </div>
               </div>
             </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="py-24 bg-gray-50 dark:bg-gray-900/50">
        <div className="max-w-7xl mx-auto px-6">
          <div className="text-center mb-16">
            <h2 className="text-3xl font-bold text-gray-900 dark:text-white mb-4">Everything you need to succeed</h2>
            <p className="text-gray-600 dark:text-gray-400 max-w-2xl mx-auto">We provide the tools to help you hit your goals, whether you are trying to lose weight, gain muscle, or just eat healthier.</p>
          </div>
          
          <div className="grid md:grid-cols-3 gap-8">
            <FeatureCard 
              icon={<Target className="w-6 h-6 text-green-600" />}
              title="Personalized Goals"
              description="Set custom targets for calories, protein, carbs, and fats based on your unique body profile."
            />
            <FeatureCard 
              icon={<Apple className="w-6 h-6 text-green-600" />}
              title="Smart Food Library"
              description="Instantly access thousands of verified foods or quickly add your custom recipes to the database."
            />
            <FeatureCard 
              icon={<Droplets className="w-6 h-6 text-green-600" />}
              title="Hydration Tracking"
              description="Never forget to drink water again with our easy-to-use hydration logging and reminders."
            />
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="bg-white dark:bg-gray-950 py-12 border-t border-gray-100 dark:border-gray-800">
        <div className="max-w-7xl mx-auto px-6 flex flex-col md:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <Activity className="text-green-500 w-6 h-6" />
            <span className="font-bold text-lg text-gray-900 dark:text-white">NutritionTracker</span>
          </div>
          <p className="text-gray-500 dark:text-gray-400 text-sm">
            © {new Date().getFullYear()} NutritionTracker App. All rights reserved.
          </p>
          <div className="flex items-center gap-4 text-sm font-medium text-gray-500 dark:text-gray-400">
            <Link to="/about" className="hover:text-gray-900 dark:hover:text-white transition-colors">About Us</Link>
            <Link to="/privacy" className="hover:text-gray-900 dark:hover:text-white transition-colors">Privacy Policy</Link>
            <a href="#" className="hover:text-gray-900 dark:hover:text-white transition-colors">Terms</a>
          </div>
        </div>
      </footer>
    </div>
  );
}

function FeatureCard({ icon, title, description }) {
  return (
    <div className="bg-white dark:bg-gray-800 p-8 rounded-3xl border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-md transition-shadow group">
      <div className="w-12 h-12 rounded-2xl bg-green-50 dark:bg-green-500/10 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300">
        {icon}
      </div>
      <h3 className="text-xl font-bold text-gray-900 dark:text-white mb-3">{title}</h3>
      <p className="text-gray-600 dark:text-gray-400 leading-relaxed">
        {description}
      </p>
      <ul className="mt-6 space-y-2">
        {['Quick entry', 'Detailed insights', 'Progress charts'].map((item, i) => (
          <li key={i} className="flex items-center gap-2 text-sm text-gray-600 dark:text-gray-400">
            <CheckCircle2 className="w-4 h-4 text-green-500 flex-shrink-0" />
            {item}
          </li>
        ))}
      </ul>
    </div>
  );
}

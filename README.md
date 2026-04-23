# 🥗 Nutrition Tracker

A premium, AI-powered nutrition and health tracking application built with Flutter and Firebase. This app leverages Google's Gemini AI to analyze food images and provide instant nutritional insights.

## 🚀 Features

- **AI Food Scanner**: Snap a photo of your meal and let Gemini 1.5 Flash calculate calories and protein.
- **Daily Dashboard**: Interactive health score gauge, nutrient progress tracking, and water intake monitoring.
- **Water Tracker**: Quick-add system with daily goals and visual progress glass-fill animation.
- **Historic Data**: Select any date to view past nutrition logs and health metrics.
- **User Profiles**: Personalized data persistence and profile management.
- **Real-time Sync**: Instant updates across devices using Cloud Firestore.

## 🛠 Tech Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider
- **Backend**: Firebase (Auth & Firestore)
- **AI Engine**: Google Gemini 1.5 Flash
- **Design**: Material 3 with Custom Premium UI Components

---

## 📊 Database Architecture (Firestore)

The database is architected for maximum scalability and cost-efficiency using a **Document-Oriented NoSQL** approach.

### Current Optimizations:
1.  **Distributed Subcollections**: Data is stored under `users/{userId}/logs` and `users/{userId}/daily_tracking`, ensuring queries never scan unnecessary documents from other users.
2.  **Point Lookups**: Daily metrics (like water) use a deterministic ID (`YYYY-MM-DD`). This creates a "Point Lookup" which is the fastest and cheapest operation in Firestore.
3.  **Atomic Operations**: Uses `FieldValue.increment` for water tracking to prevent race conditions and ensure data integrity without expensive "read-before-write" operations.
4.  **Automatic Indexing**: Queries are structured to leverage Firestore's single-field indexes, maintaining high performance as the dataset grows.

---

## 🔮 Future-Proofing & Scalability

### MongoDB Migration Path
The application is designed using a **Service-Oriented Architecture (SOA)**, making it ready for a future migration to a custom backend like **MongoDB** if needed.

**Why it's possible:**
- **Data Compatibility**: Firestore and MongoDB share the same JSON-like document philosophy.
- **Decoupled Logic**: Database logic is isolated in `NutritionService`. Migrating only requires replacing this service layer; the UI and business logic (Providers) remain untouched.
- **Flexible Schema**: The current `FoodEntry` and `UserProfile` models map directly to MongoDB BSON structures.

---

## 📂 Project Structure

```text
lib/
├── core/               # App-wide constants, themes, and utils
├── features/
│   ├── auth/           # Login, Sign Up, and Auth Providers
│   ├── nutrition/      # AI Scanner, Dashboard, and Food Logs
│   │   ├── models/     # Data entities
│   │   ├── providers/  # Business logic & state
│   │   ├── services/   # Firebase communication
│   │   └── screens/    # UI Views
│   └── profile/        # User settings and profile info
└── main.dart           # App entry point
```

## ⚙️ Getting Started

1.  **Clone the repo**: `git clone https://github.com/pankajkcodes/Nutrition-Tracker.git`
2.  **Install dependencies**: `flutter pub get`
3.  **Setup Firebase**: Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
4.  **Add Gemini API Key**: Replace the key in `lib/features/nutrition/services/ai_service.dart`.
5.  **Run**: `flutter run`

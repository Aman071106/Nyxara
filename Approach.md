# 🚀 Nyxara Flutter App

A modern Flutter application built using clean architecture principles, integrated with Firebase and Supabase for web deployment and backend functionality.

---

## 🧠 Development Flow (What I Learned)

### 📦 Backend First (API)
- Use **TypeScript** or **Python** to create custom API endpoints.
- Deploy backend APIs to platforms like Render, Railway, or Firebase Functions.

### 🌐 Data Layer
- Set up **DataSources** to call both local and deployed API endpoints.
- Test endpoints manually with Postman/Thunder Client.

### 🧱 Domain Layer
- Define abstract classes for repositories and business logic.

### 🧪 Repository Implementation & Testing
- Implement the repo using API and local storage.
- Write unit tests to validate logic.

---

## 🧑‍💻 UI Development

- Start UI after domain + repo layers are verified.
- Use **Bloc** or **Riverpod** for state management.
- Build small, testable components.
- Structure UI widgets into `widgets/` directory.
- **Logging is extremely important**: add logs while debugging but remove them before deploying.

---

## 🔐 Auth First
- Start by implementing **Authentication** (Login, Signup).
- Store tokens using `shared_preferences`.
- Extend this pattern for other features.

---

## 🧪 Testing
- Write tests alongside feature development:
  - Repository tests
  - Bloc tests
  - Widget tests

---

## 🌍 Web Deployment on Firebase

### ❌ Problem
`flutter_dotenv` **does NOT work on Flutter web builds.**

### ✅ Solution
Use `String.fromEnvironment` to access environment variables at build time.

### 🛠️ Build Command
Replace variables with your actual values:

```bash
flutter build web --release \
  --dart-define=SERVICE_ID=your_service_id \
  --dart-define=TEMPLATE_ID=your_template_id \
  --dart-define=PRIVATE_KEY=your_private_key \
  --dart-define=PUBLIC_KEY=your_public_key \
  --dart-define=POSTGRE_URL=your_url \
  --dart-define=ANNON_KEY=your_key \
  --dart-define=NONCE=1,2,3 \
  --dart-define=TABLE_NAME=your_table \
  --dart-define=VERIFICATION_PASS=your_pass

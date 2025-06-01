# 🌌 Nyxara
https://chatgpt.com/c/67fe0eea-a004-8004-a46e-470f8dd5b763
**Nyxara** is a Flutter WebApp designed to detect data breaches using the Have I Been Pwned (HIBP) API and provide AI-powered assistance and security advice. Inspired by **Nyx** (goddess of night) and **Ara** (defense/guard), the app aims to be your night guardian in the digital world.

---

## 🧠 Core Functionality

```
[User enters Email/Phone]
       ↓
Flutter frontend sends request to backend → /api/check-breach
       ↓
Backend validates + checks breach via HIBP API
       ↓
If breached → uses GenAI to explain in simple language
       ↓
Response sent back to frontend → Shows user + stores in Hive
       ↓
Push notifications enabled (via Firebase) for future breaches
       ↓
VPN/IP status periodically fetched via VPN API
       ↓
Vault uses encrypted local storage to store sensitive info
```

---

## 🛠️ Methodology

### Step 1: Scalable Backend API
- Endpoint to check breach via email or phone
- Stream-like breach monitoring endpoint

### Step 2: AI Agents
- **BreachCheck Response Analyzer**
- **Past Reports Reading Agent** (with database)
- **Advisor Agent**
- **Vault Manager Agent** (if required)

### Step 3: Flutter WebApp (Final Product Features)
- Email/password-based user authentication
- Profile screen (name, email, phone)
- Monitoring screen for past alerts
- Vault screen for storing sensitive info
- AI Assistance + Breach Checker screen
- Simple AI-powered assistant bot for website insights

> 🧩 MCP architecture followed. Clean, non-hardcoded code with placeholder UI (to be upgraded later).

---

## 🗂️ Project Structure

### 📦 Backend (`/backend`)
```
backend/
├──src/
       ├── controllers/
       ├── services/
       ├── routes/
       ├── models/
       ├── sockets/
       ├── ai_agents/
       ├── app.ts
       └── server.ts
├── .env
├── node_modules
├── tsconfig.json
└── package.json
└── package-lock.json

backend deployment => render

https://nyxara-backend.onrender.com/api/check-breach-analytics?email=aman@gmail.com
https://nyxara-backend.onrender.com/api/check-email?email=aman@gmail.com
```

### 📦 Flutter WebApp (`/flutter_web`)
```
flutter_web/
├── lib/
│   ├── screens/
│   ├── providers/
│   ├── models/
│   ├── services/
│   ├── utils/
│   └── main.dart
```

---

## 📬 Future Enhancements

- Multi-platform support (mobile, desktop)
- Improved UI/UX with dark mode
- Admin dashboard for breach analysis
- Integration with more breach databases
- Enhanced AI capabilities with memory

---

## 🛡️ License

MIT License. Feel free to fork and contribute to improve digital security.

---

## 💬 Contributions

Open to contributions! Please open issues or submit PRs.

---

> Made with 💙 using Flutter, Node.js, and AI


Frontend architecture

lib/
├── core/                  
│   ├── router/(#Gorouter)
│      ├── routes_consts.dart
│      ├── router_config.dart
│   ├── theme/(only dark theme)
│      ├── AppColors.dart       
│   ├── constants/
│      ├── AppDimensions.dart
│      ├── AppStrings.dart
│   └── utils/
│             bycryption_utils.dart
├── data/                  # Data Layer
│   ├── datasources/
│   └── repositories/
│   ├── models/
├── domain/                # Domain Layer
│   ├── entities/
│   ├── usecases/
│   ├── repositories_impl/
├── presentation/          # UI Layer
│   ├── common/            
│      ├── navbar.dart
│      ├── app_assistance_bot.dart  (#backend structure remaining)
│   ├── auth/
│      ├── bloc/
│      ├── screens/
│             ├── auth_screen.dart
│   ├── vault/
│      ├── bloc/
│      ├── screens/
│             ├── vault_screen.dart
│   ├── breach_analytics/
│      ├── bloc/
│      ├── screens/
│             ├── breach_analytics_screen.dart
│   ├── advisor_agent/
│      ├── bloc/
│      ├── screens/
│             ├── advisor_agent_screen.dart
│      ├── widgets/
│   ├── about/
│      ├── bloc/
│      ├── screens/
│             ├── auth_screen.dart
│   └── pawned/
│      ├── bloc/
│      ├── screens/
│             ├── pawned_screen.dart
└── main.dart


what i found!!
flutter web doesn't support native mongo_dart package

BLOC->USECASES->REPO OF DOMAIN->REPO IMPL IN DATA->USE DATA SOURCE


3-d 
o3d package
https://www.youtube.com/watch?v=-W45PQ__SAk&t=203s
https://pub.dev/packages/o3d




//vault backend decision:
->getall method
->update value for a specific key
->delete item by key
->put new item in db by key

//update password in profile also required along with google auth


//bugs:
->api calls after switching tabs(shared_pref)
->backend vault
->otp ui
->code cleaning
->widgets folder
->entity-model conversion in vault
->firebase deployment

Using mailer in flutter:
We need to go to myaccounts.google.com/apppasswords
and generate a apppassword for app

then send otp to emails via smtp protocol
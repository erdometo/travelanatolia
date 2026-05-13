# 🧭 TravelAnatolia V2 (Agentic Travel Architect)

> **Status:** Currently refactoring legacy V1 into a modern multi-agent architecture with strict JSON schema outputs and Genkit routing.

TravelAnatolia V2 is an evolution of the original travel companion, now architected as a sophisticated multi-agent system. It leverages agentic workflows to provide precise, personalized, and context-aware travel planning for exploring Anatolia.

---

## ✨ Features

| Feature | Description |
|---|---|
| 🤖 **Agentic Assistant** | Multi-agent architecture using LangGraph for complex reasoning and Genkit for routing |
| 🗺️ **Explore Screen** | Bento-grid discovery of destinations, activities, food, and culture — filterable by category |
| 📋 **Itinerary Architect** | Strict JSON schema outputs ensuring perfectly formatted, actionable travel plans |
| 👤 **Identity Profiling** | Deep user preference analysis to power agentic personalization |
| 🔐 **Authentication** | Firebase Auth with redirect-based navigation guard |
| 🎨 **Stitch Design System** | Custom dark-mode theme with Google Fonts, consistent tokens, and micro-animations |

---

## 🏗️ Tech Stack

### AI & Backend
| Technology | Purpose |
|---|---|
| **TypeScript** | Core logic and type-safe agent development |
| **Firebase Genkit** | AI orchestration and model routing |
| **LangGraph** | Multi-agent workflow orchestration and state management |
| **PostgreSQL** | Relational data storage for complex travel entities |
| **Zod** | Strict JSON schema validation for all agent outputs |

### Flutter App (Frontend)
| Package | Purpose |
|---|---|
| `flutter_riverpod ^3.3.1` | State management (providers, async state) |
| `go_router ^17.2.3` | Declarative navigation with auth guards |
| `firebase_core / auth / firestore` | Firebase platform integration |
| `google_fonts ^8.1.0` | Typography (Stitch design system) |

---

## 📁 Project Structure

```
APP/
├── lib/
│   ├── main.dart                   # App entry point, Firebase init, emulator config
│   ├── router.dart                 # GoRouter with auth-based redirect guards
│   ├── firebase_options.dart       # Auto-generated Firebase configuration
│   ├── ui/
│   │   ├── theme.dart              # TravelAnatolia MaterialTheme (Stitch design system)
│   │   ├── scaffold_with_nav_bar.dart  # Persistent bottom nav shell
│   │   ├── stitch_components/      # Reusable branded UI components
│   │   └── widgets/                # General shared widgets
│   └── features/
│       ├── auth/                   # Login screen + auth state provider
│       ├── onboarding/             # Multi-step identity quiz screen
│       ├── assistant/              # ANA chat screen + message provider
│       ├── explore/                # Destination grid + category filtering
│       ├── itinerary/              # Itinerary list & detail screen
│       └── profile/                # User profile screen
├── firebase/
│   └── functions/
│       └── src/
│           ├── index.ts            # Cloud Function exports
│           ├── test_data.ts        # Seed data for emulator testing
│           └── genkit/
│               ├── config.ts       # Genkit + Gemini plugin setup
│               ├── flows/          # assistantFlow — the core AI conversation flow
│               └── tools/          # Genkit tools (callable by the AI)
├── firebase.json                   # Emulator ports & project config
├── firestore.indexes.json          # Firestore composite indexes
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.11.5
- [Firebase CLI](https://firebase.google.com/docs/cli) installed and logged in
- [Node.js](https://nodejs.org/) v22 (for Firebase Functions)
- A Firebase project linked at `travelanatolia-prod`

### 1. Install Flutter Dependencies

```bash
flutter pub get
```

### 2. Install Cloud Functions Dependencies

```bash
cd firebase/functions
npm install
```

### 3. Start Firebase Emulators

From the project root (`APP/`):

```bash
firebase emulators:start
```

This starts:
- **Auth Emulator** → `localhost:9099`
- **Firestore Emulator** → `localhost:8080`
- **Functions Emulator** → `localhost:5001`
- **Emulator UI** → `localhost:4000`

> **Note:** The app connects to emulators via the IP `192.168.1.6` in debug mode. Update `main.dart` if your local machine IP differs.

### 4. Run the Flutter App

```bash
flutter run
```

---

## 🤖 AI Assistant (ANA)

ANA is powered by **Google Gemini** through the [Firebase Genkit](https://firebase.google.com/docs/genkit) framework.

- The Flutter app calls the `chatWithAssistant` Firebase Callable Function via `cloud_functions`.
- Genkit orchestrates the `assistantFlow`, which constructs a prompt enriched with the user's travel identity profile from Firestore.
- Responses are streamed back to the chat UI.

### Cloud Functions

| Function | Trigger | Description |
|---|---|---|
| `chatWithAssistant` | HTTPS Callable | Invokes the Genkit `assistantFlow` for AI chat |
| `onUserOnboardingUpdate` | Firestore Write | Aggregates onboarding quiz answers into the user's identity profile |

---

## 🔐 Authentication & Navigation

Navigation is handled by `GoRouter` with an auth guard:

- **Unauthenticated users** → redirected to `/login`
- **Authenticated users** → land on `/` (ANA Chat)
- **New users** → routed through `/onboarding` to complete their identity quiz

The router reacts to `authProvider` changes via a `ChangeNotifier` bridge, ensuring seamless real-time redirects on login/logout.

---

## 🧑‍💻 Development Notes

### Emulator IP
The emulator host is hardcoded to `192.168.1.6` in `main.dart`. Change this to `localhost` or your machine's LAN IP as needed:

```dart
// lib/main.dart
FirebaseFirestore.instance.useFirestoreEmulator('YOUR_IP', 8080);
await FirebaseAuth.instance.useAuthEmulator('YOUR_IP', 9099);
FirebaseFunctions.instanceFor(region: 'europe-west3').useFunctionsEmulator('YOUR_IP', 5001);
```

### Build Functions (TypeScript)

```bash
cd firebase/functions
npm run build          # compile once
npm run build:watch    # watch mode for development
```

### Lint & Analysis

```bash
flutter analyze
```

---

## 📱 Supported Platforms

| Platform | Status |
|---|---|
| Android | ✅ Supported |
| iOS | ✅ Supported |
| Web | 🚧 Not configured |
| Desktop | 🚧 Not configured |

---

## 📄 License

Private project — no rights given to use it anywhere else without written permission from Erdem Metin.

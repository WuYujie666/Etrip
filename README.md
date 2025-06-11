
# Egyptopia 🇪🇬✨

**Egyptopia** is a smart tourism mobile application built with Flutter to redefine how users explore, discover, and plan travel across Egypt. Combining AI, clean architecture, and rich cultural content, the app delivers a personalized and immersive experience for both local and international travelers.

---

## 🌍 App Highlights

- 🎓 **Graduation Project – Grade: Excellent**
- 🧠 AI-based itinerary & recommendations
- 📲 Cross-platform (Flutter)
- 🔐 Firebase Authentication (Email + Google)
- 🌐 Connected to custom RESTful APIs
- 🗺️ Google Maps Integration & Deep Linking
- 🧱 Clean MVVM Architecture (BLoC + GetX)

---

## 🧠 Smart Features

### ✅ Role-Based Access
- **Guest Mode** with limited access
- **Registered Users** enjoy full access including recommendations, itinerary, wishlist, and personalization

### 🎬 Splash & Onboarding
- **Splash Screen** with animated logo
- Multi-step **Onboarding Flow** to introduce app features

### 🏠 Home Screen
- Modular, scrollable dashboard
- Sections include: **Top Places**, **Popular Activities**, **Suggested Events**, **Cultural Picks**, and **Quick Access**

### 🔍 Smart Search
- Real-time debounced search across:
  - Places
  - Activities
  - Events
- Categorized results with smooth UX

### 📍 Places Module
- Explore historical, natural, religious, and coastal places
- Advanced filters:
  - **City**
  - **Tourism Type**
  - **Category**
  - **Popularity**
- Add to wishlist or itinerary
- Deep link to directions in Google Maps

### 🎯 Activities & Events
- Discover and filter fun things to do and live events
- Filters by **type**, **location**, and **price**
- Save to itinerary or favorites

### 🧭 Interactive Map Mode
- Explore visually using markers for all places & activities
- Tap any marker to view full details or navigate

### ✈️ Itinerary Planner
- Build your custom trip plan day-by-day
- Add/remove places and events dynamically
- Highlights suggested places based on preferences

### ❤️ Wishlist
- Save your favorite Places, Activities, and Events
- Organized tabs per type
- Supports offline storage using Hive

### 🍽️ Food & Drinks
- Educational content showcasing famous Egyptian meals and beverages
- Visuals + descriptions for cultural exploration

### ❓ Quizzes
- Engaging, educational quizzes about Egypt’s culture, history, and geography
- Ideal for tourists and learners

### ☁️ Weather
- Auto-detects current location for weather
- Search governorates manually
- Fully localized and integrated

### 🗨️ AI Chatbot
- Smart assistant for travel help
- Answers questions, suggests places, and helps plan on the go

### 👤 Profile Management
- Fully editable: Name, Photo, Password, Preferences
- Preferences directly influence smart suggestions

---

## 🧱 Folder Structure

```bash
lib/
├── core/                   # Reusable components, constants, themes, routing
├── features/
│   ├── splash/             # Animated splash screen
│   ├── onboarding/         # Multi-screen onboarding flow
│   ├── home/               # Home layout & sections
│   ├── search/             # Real-time search engine
│   ├── places/             # Explore & filter places
│   ├── activities/         # Activity listing & filtering
│   ├── events/             # Upcoming events
│   ├── map/                # Interactive map mode
│   ├── itinerary/          # Trip builder system
│   ├── wishlist/           # Favorites (Places, Activities, Events)
│   ├── food_and_drinks/    # Informational cultural content
│   ├── quizzes/            # Mini-games & knowledge checks
│   ├── weather/            # Weather info and search
│   ├── chatbot/            # Smart travel assistant
│   └── profile/            # Edit profile, change password, preferences
└── main.dart
```

---

## 🛠️ Technologies Used

| Category         | Tools & Technologies                                   |
|------------------|--------------------------------------------------------|
| **Framework**     | Flutter, Dart                                          |
| **State Management** | GetX + BLoC (clean MVVM hybrid)                     |
| **Backend**        | Firebase Auth, RESTful APIs                           |
| **UI/UX**          | Figma, Custom Animations, Modular Widgets             |
| **APIs & Services**| Google Maps, Location, Weather, Image Picker          |
| **Storage**        | Hive,                                                 |
| **Testing**        | Functional Testing & Unit Testing (in progress)       |

---

## ▶️ Getting Started

```bash
git clone https://github.com/Mo7medRef3t/Egyptopia.git
cd Egyptopia
flutter pub get
flutter run
```

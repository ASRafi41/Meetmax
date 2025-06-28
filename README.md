# Meetmax

Meetmax is a Facebook‑style social media demo built with Flutter and Dart. It features user authentication, a personalized feed with stories and posts, and interactive features like liking, commenting and creating posts—all powered by a local Hive “mock backend.” The UI strictly follows provided Figma designs and adapts responsively to different screen sizes.

---

## 🔧 How to Set Up, Run, and Test the Application

### ✅ Prerequisites
- Flutter SDK ≥ 2.10
- Dart SDK
- An IDE such as VS Code or Android Studio

### 🛠 Setup Instructions
1. **Clone the repository**
   ```bash
   git clone https://github.com/ASRafi41/Meetmax.git
   cd Meetmax
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive type adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```
   On first launch, the app will auto‑seed mock users, stories, posts, and comments into Hive.

---

## 📁 Project Structure

```
lib/
├── mock_server/                # Hive box definitions & seed data
│   ├── hive_boxes.dart
│   ├── seed_data.dart
│   └── user_service.dart
├── models/                     # Hive data models
│   ├── comment.dart
│   ├── post.dart
│   ├── story.dart
│   └── user.dart
├── providers/                  # ChangeNotifier providers
│   ├── auth_provider.dart
│   ├── comment_provider.dart
│   ├── post_provider.dart
│   ├── story_provider.dart
│   └── user_provider.dart
├── screens/                    # Screen-level UI
│   ├── feed_screen.dart
│   ├── forgot_password_screen.dart
│   ├── signin_screen.dart
│   └── signup_screen.dart
├── widgets/                    # Reusable UI components
│   ├── post_card.dart
│   ├── post_input.dart
│   └── story_list.dart
└── main.dart                   # App entry point
```

---

## 🛠 Tools & Technologies Used

- **Flutter** & **Dart**
- **Hive** for local data persistence
- **Provider** for state management
- **FontAwesome** & **Material Icons** for UI

---

## ✨ Features

- **Authentication**
    - Sign In / Sign Up
    - Form validation, “Remember Me” toggle

- **Feed Screen**
    - Horizontally scrollable stories
    - Search bar to filter posts by content/username
    - Pull‑to‑refresh & infinite‑scroll of posts

- **State & Persistence**
    - Provider for real‑time state updates
    - Hive for local storage of users, sessions, stories, posts, comments

---

## 🖼 Screenshots

| Sign Up              | Sign In               |
|----------------------|-----------------------|
| `assets/screenshots/SignUp.jpg` | `assets/screenshots/SignIn.jpg` |

| Feed Screen                         | Create Post                           |
|-------------------------------------|---------------------------------------|
| `assets/screenshots/FeedScreen.jpg` | `assets/screenshots/CreatePost.jpg`   |

| Forget Password                         |
|-----------------------------------------|
| `assets/screenshots/ForgetPassword.jpg` |

---

## 📄 Assumptions & Simulated Backend

- All data (users, posts, stories) is stored locally via Hive.
- No external API or real backend—API calls are simulated with delays.
- Social‑login buttons (Google/Apple) are nonfunctional placeholders.
- Images are loaded from placeholder URLs.  
- ⚠️ Like, comment, and share features are not available in this demo.

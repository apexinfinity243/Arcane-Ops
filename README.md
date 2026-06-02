# ARCANE-OPS 🎯

A Flutter application featuring a modern Matrix-inspired hacker dark theme with authentication and messaging capabilities.

## Features ✨

- **Authentication System**
  - User Registration with comprehensive validation
  - Login with email or phone number
  - Password strength requirements
  - Phone number verification
  - Email verification
  - Date of birth validation (DD/MM/YYYY format)
  - Country code selector for phone numbers

- **User Interface**
  - Matrix rain animation effects
  - Dark Arch Linux hacker aesthetic
  - Neon green (#00FF00) and cyan accents
  - Smooth animations and transitions
  - Responsive design
  - Realistic glass-morphism buttons

- **Messaging**
  - Real-time messaging
  - Messenger-like interface
  - User profiles
  - Dynamic and responsive UI

## Tech Stack 🛠️

- **Framework**: Flutter (Dart)
- **Backend**: Firebase (Authentication, Firestore, Storage)
- **State Management**: Provider + GetX
- **UI Libraries**: Flutter Material Design 3
- **Animations**: Custom animations and Lottie

## Project Structure 📁

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   │   └── app_constants.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── validators.dart
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   └── auth/
│       ├── welcome_screen.dart
│       ├── login_screen.dart
│       ├── signup_screen.dart
│       └── verification_screen.dart
└── firebase_options.dart
```

## Setup Instructions 🚀

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio with Android SDK
- Firebase project configured

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Arcane-Ops.git
   cd Arcane-Ops
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at https://console.firebase.google.com
   - Add Android app to your Firebase project
   - Download `google-services.json` and place it in `android/app/`
   - Update `firebase_options.dart` with your Firebase credentials

4. **Run the app**
   ```bash
   flutter run
   ```

## Theme Customization 🎨

The app uses a custom dark theme defined in `core/theme/app_theme.dart`:
- **Primary Color**: Neon Green (#00FF00)
- **Secondary Color**: Neon Blue (#0088FF)
- **Background**: Dark Blue Black (#0A0E27)
- **Text**: Neon Green with cyan accents

## Validation Features ✅

- **Email**: Standard email format validation
- **Password**: Minimum 8 characters, uppercase, lowercase, numbers required
- **Phone**: Format validation (not real number checking)
- **Date**: DD/MM/YYYY format with age verification (min 13 years)
- **Names**: 2-50 characters
- **Confirm Password**: Must match password field

## Firebase Collections Structure 📊

```
users/
├── uid/
│   ├── firstName
│   ├── lastName
│   ├── postName
│   ├── birthDate
│   ├── phoneNumber
│   ├── email
│   ├── createdAt
│   └── avatar

conversations/
├── conversationId/
│   ├── participants
│   ├── lastMessage
│   ├── lastMessageTime
│   └── updatedAt

messages/
├── conversationId/
│   ├── messageId/
│   │   ├── senderId
│   │   ├── text
│   │   ├── timestamp
│   │   └── read

verification_codes/
├── phoneNumber/
│   ├── code
│   ├── expiresAt
│   └── verified
```

## Development Notes 📝

- Phone number validation does NOT check if the number is real
- Matrix rain effect uses custom paint for performance
- All transitions are smooth with 300-400ms durations
- Responsive design handles various screen sizes

## License 📄

MIT License - Feel free to use this project for your own purposes.

## Support 💬

For issues and questions, please open an issue on GitHub.

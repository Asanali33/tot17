# TaskFlow - Productivity App

A comprehensive Flutter task management application with productivity analytics, multi-language support, and backend storage.

## 🚀 Quick Start - Small Phone Cold Boost Emulator

This project is specifically configured to run on the **Small Phone Cold Boost** Android emulator for optimal development experience.

### Prerequisites
- Flutter SDK 3.41.4+
- Android Studio with Android SDK 36.1.0
- Android NDK 28.2.13676358
- Android Emulator
- MongoDB (local or Atlas)

### 🔧 Android SDK/NDK Verification

Run the verification script to ensure all components are properly installed:

```bash
# Windows
verify_android_setup.bat
```

This script will check:
- ✅ Android SDK installation
- ✅ Android NDK 28.2.13676358
- ✅ Android Emulator
- ✅ Android Platform Tools (ADB)
- ✅ Flutter Android licenses

### 📱 Launch Small Phone Cold Boost Emulator

Use the dedicated launcher script:

```bash
# Windows
launch_emulator.bat
```

This script will:
1. Verify Android SDK/NDK installation
2. Create "Small Phone Cold Boost" AVD if it doesn't exist
3. Start the emulator with optimized settings:
   - Cold boot (no snapshot)
   - 2GB RAM
   - 2 CPU cores
   - SwiftShader GPU acceleration
   - 1080x2400 resolution

### 🗄️ Backend Setup

TaskFlow now includes a backend for persistent task storage using MongoDB.

#### Prerequisites
- MongoDB installed locally or MongoDB Atlas account

#### Start Backend
```bash
# Windows
backend\start_backend.bat
```

This will start the Dart backend server on http://localhost:8080

#### Backend Features
- RESTful API for task CRUD operations
- MongoDB integration for data persistence
- CORS enabled for Flutter app communication
- Automatic task synchronization

### 🛠️ Development in VS Code

1. **Automatic Setup**: Use the "TaskFlow - Small Phone Cold Boost" debug configuration
   - This will automatically launch the emulator and start the app

2. **Manual Launch**: After emulator is running:
   ```bash
   flutter run --device-id emulator-5554
   ```

### 📊 Features

- ✅ Task management with categories and priorities
- ✅ Productivity analytics with charts
- ✅ Procrastination tracking and analysis
- ✅ Workload forecasting
- ✅ Multi-language support (Russian/English)
- ✅ Dark/Light theme switching
- ✅ Local data persistence

### 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── task.dart            # Task data model
├── services/
│   └── task_service.dart    # Business logic & analytics
├── screens/
│   ├── main_screen.dart     # Main navigation
│   ├── home_screen.dart     # Task list & management
│   ├── stats_screen.dart    # Basic statistics
│   ├── analytics_screen.dart # Advanced productivity analytics
│   └── settings_screen.dart # App settings
├── widgets/
│   └── task_tile.dart       # Task item widget
└── l10n/                    # Localization files
    ├── app_en.arb
    └── app_ru.arb
```

### 🎯 Analytics Features

The app includes comprehensive productivity analytics:

1. **Completed Tasks Chart** - Track daily task completion over 30 days
2. **Procrastination Analysis** - Pie chart of procrastination reasons
3. **Average Completion Time** - Time metrics for task completion
4. **Workload Forecast** - 7-day ahead task planning

### 🌍 Localization

The app supports Russian and English languages with automatic detection based on device settings.

### 📱 Emulator Configuration

**Small Phone Cold Boost** specifications:
- Device: Pixel 7a (small phone form factor)
- API Level: 35 (Android 15)
- Architecture: x86_64
- RAM: 2048 MB
- CPU Cores: 2
- GPU: SwiftShader (software rendering)
- Resolution: 1080x2400

This configuration provides optimal performance for development while maintaining realistic device characteristics.

## 🔧 Development Commands

```bash
# Verify setup
./verify_android_setup.bat

# Launch emulator
./launch_emulator.bat

# Run on specific device
flutter run --device-id emulator-5554

# Build APK
flutter build apk --target-platform android-arm64

# Generate localization
flutter gen-l10n

# Run tests
flutter test

# Analyze code
flutter analyze
```

## 📋 Requirements

- **Flutter**: 3.41.4
- **Dart**: 3.11.1
- **Android SDK**: 36.1.0
- **Android NDK**: 28.2.13676358
- **Java**: 17
- **Android Emulator**: 36.4.9.0

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make changes
4. Run tests: `flutter test`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

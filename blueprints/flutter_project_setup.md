# Coherency Flutter Project Setup Guide

## Project Structure Overview

```
coherency/
├── android/                    # Android-specific configurations
├── ios/                       # iOS-specific configurations  
├── lib/                       # Main Flutter application code
│   ├── core/                  # Core utilities and constants
│   │   ├── constants/         # App constants
│   │   ├── utils/            # Utilities and helpers
│   │   ├── services/         # Core services
│   │   └── network/          # API service layer
│   ├── data/                 # Data layer
│   │   ├── models/           # Data models
│   │   ├── repositories/     # Repository pattern implementation
│   │   └── datasources/      # Local and remote data sources
│   ├── domain/               # Business logic layer
│   │   ├── entities/         # Business entities
│   │   ├── repositories/     # Repository interfaces
│   │   └── usecases/         # Business use cases
│   ├── presentation/         # UI layer
│   │   ├── screens/          # App screens
│   │   ├── widgets/          # Reusable widgets
│   │   ├── bloc/             # State management (BLoC pattern)
│   │   └── themes/           # App themes and styling
│   └── main.dart             # App entry point
├── assets/                   # Static assets
│   ├── images/
│   ├── fonts/
│   └── icons/
├── test/                     # Unit and widget tests
├── integration_test/         # Integration tests
└── docs/                     # Documentation

```

## Initial Flutter Setup Commands

### 1. Create Flutter Project
```bash
flutter create coherency
cd coherency
```

### 2. Update pubspec.yaml Dependencies
```yaml
name: coherency
description: A comprehensive medical app with LiDAR wound detection, patient management, and healthcare services

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_bloc: ^8.1.3
  get_it: ^7.6.4
  injectable: ^2.3.0
  
  # Networking
  dio: ^5.3.2
  retrofit: ^4.0.3
  json_annotation: ^4.8.1
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.2
  
  # UI Components
  flutter_svg: ^2.0.7
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  flutter_spinkit: ^5.2.0
  
  # Camera and Media
  camera: ^0.10.5+5
  image_picker: ^1.0.4
  permission_handler: ^11.0.1
  
  # Maps and Location
  google_maps_flutter: ^2.5.0
  geolocator: ^10.1.0
  geocoding: ^2.1.1
  
  # Authentication
  firebase_auth: ^4.12.0
  google_sign_in: ^6.1.5
  
  # Push Notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.1.0
  
  # Payment Integration
  razorpay_flutter: ^1.3.5
  stripe_payment: ^1.1.4
  
  # File Handling
  file_picker: ^6.1.1
  path_provider: ^2.1.1
  
  # Date and Time
  intl: ^0.18.1
  
  # Validation
  formz: ^0.6.1
  
  # Connectivity
  connectivity_plus: ^5.0.1
  
  # Device Info
  device_info_plus: ^9.1.0
  
  # LiDAR and 3D (iOS specific)
  arkit_plugin: ^0.11.0
  
  # Custom packages for medical features
  # (These would be custom packages you'll develop)
  wound_detection_sdk: ^1.0.0
  medical_data_validator: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  
  # Code Generation
  build_runner: ^2.4.7
  json_serializable: ^6.7.1
  retrofit_generator: ^8.0.4
  injectable_generator: ^2.4.0
  hive_generator: ^2.0.1
  
  # Testing
  mockito: ^5.4.2
  bloc_test: ^9.1.5
  integration_test:
    sdk: flutter

flutter:
  uses-material-design: true
  
  assets:
    - assets/images/
    - assets/icons/
    - assets/fonts/
  
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-Medium.ttf
          weight: 500
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
        - asset: assets/fonts/Inter-Bold.ttf
          weight: 700
```

### 3. Platform-Specific Configurations

#### Android Configuration (android/app/build.gradle)
```gradle
android {
    compileSdkVersion 34
    buildToolsVersion "30.0.3"

    defaultConfig {
        applicationId "com.coherency.medical"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
        debug {
            applicationIdSuffix ".debug"
            debuggable true
        }
    }
}

dependencies {
    implementation 'androidx.multidex:multidex:2.0.1'
    implementation 'com.google.android.gms:play-services-maps:18.2.0'
    implementation 'com.google.android.gms:play-services-location:21.0.1'
}
```

#### iOS Configuration (ios/Runner/Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for wound detection and medical documentation</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to find nearby hospitals and healthcare providers</string>
<key>NSHealthShareUsageDescription</key>
<string>This app needs access to health data for medical record management</string>
<key>NSHealthUpdateUsageDescription</key>
<string>This app needs to update health records with medical information</string>
<key>NSContactsUsageDescription</key>
<string>This app needs contacts access for emergency contact management</string>
```

## Development Environment Setup

### Required Tools and SDKs
1. **Flutter SDK** (latest stable version)
2. **Android Studio** with Android SDK
3. **Xcode** (for iOS development)
4. **VS Code** with Flutter extensions
5. **Firebase CLI** for backend services
6. **Docker** for local backend development

### Development Workflow
1. **Feature Branch Strategy**
   - main: Production-ready code
   - develop: Integration branch
   - feature/*: Individual features
   - hotfix/*: Critical fixes

2. **Code Quality Tools**
   - ESLint/Dart Analysis
   - Automated testing (Unit, Widget, Integration)
   - CI/CD pipeline with GitHub Actions

3. **Development Phases**
   - Phase 1: Core app structure and authentication
   - Phase 2: Patient management and basic features
   - Phase 3: LiDAR integration and wound detection
   - Phase 4: E-commerce and service booking
   - Phase 5: Advanced features and AI integration

## Key Development Considerations

### Security
- Implement proper authentication and authorization
- Use secure storage for sensitive medical data
- Apply HIPAA compliance measures
- Implement end-to-end encryption for medical records

### Performance
- Optimize for both high-end and low-end devices
- Implement proper caching strategies
- Use lazy loading for heavy content
- Optimize image and media handling

### Scalability
- Design for horizontal scaling
- Implement proper error handling and logging
- Use microservices architecture for backend
- Plan for multi-region deployment

### Medical Compliance
- Ensure HIPAA compliance
- Implement proper data governance
- Add medical data validation
- Include audit trails for all medical operations

## Initial Project Commands

```bash
# Initialize the project
flutter create coherency
cd coherency

# Add dependencies
flutter pub get

# Generate code
flutter packages pub run build_runner build

# Run the app
flutter run

# Run tests
flutter test
flutter drive --target=test_driver/app.dart

# Build for release
flutter build apk --release
flutter build ios --release
```

This setup provides a solid foundation for your Coherency medical app with proper architecture, security considerations, and scalability in mind.
Excellent. The Flagship's keel is laid. Now, we assemble the Scout Vessel—swift, agile, and ready for action. We will ensure its internal structure is as disciplined and scalable as the backend it will communicate with.

This mission will set up the Flutter project from a blank slate to a fully-structured, professional-grade application foundation.

---

### **Mission 5.1: Genesis of the Frontend Project**

We will now occupy and construct the `frontend` directory.

**Step 1: Navigate to the Forge**

Open your terminal. Ensure your current location is the root of the project, `coherency-platform/`.

```bash
# From coherency-platform/
cd src/frontend
```
Your terminal should now be inside the empty `coherency-platform/src/frontend/` directory.

**Step 2: Create the Flutter Project**

Flutter's tooling makes this initial step straightforward. We create the project in the current directory.

Execute this command:
```bash
flutter create .
```
*   **Result:** The `frontend` directory is now populated with the default Flutter project structure, including `lib/`, `android/`, `ios/`, `pubspec.yaml`, and other necessary files.

**Step 3: Perform a Tactical Sanitization**

The default "Counter App" serves a purpose, but not ours. We require a clean foundation.

1.  **Delete the default test:** Remove the file `test/widget_test.dart`.
2.  **Gut the main logic:** Delete the file `lib/main.dart`. We will create a new, cleaner version.

---

### **Mission 5.2: Erecting the Directory Scaffolding**

A disciplined folder structure is not a suggestion; it is a law. It prevents chaos as the application grows. We are implementing a **feature-first Clean Architecture**.

**Step 1: Create the Top-Level Directories**

Inside the `lib/` directory, create the following core folders:

```bash
# From coherency-platform/src/frontend/lib/
mkdir core features
```
This gives us our primary separation: `core` for shared, app-wide logic, and `features` for self-contained feature modules.

**Step 2: Build Out the `core` Scaffolding**

The `core` directory will house everything our features share. Create its sub-folders:

```bash
# From coherency-platform/src/frontend/lib/
mkdir core/api core/config core/errors core/navigation core/services core/utils
```

*   `api/`: For setting up our HTTP client (Dio).
*   `config/`: For app-wide configuration like themes and environment variables.
*   `errors/`: For custom `Failure` and `Exception` classes.
*   `navigation/`: For our `GoRouter` setup and route definitions.
*   `services/`: For our service locator setup (`GetIt`).
*   `utils/`: For constants, formatters, and other general utilities.

**Step 3: Build a Sample `features` Module Scaffolding**

We will now create the full structure for our *first* feature: **Authentication**. This will serve as the template for all future features.

```bash
# From coherency-platform/src/frontend/lib/
mkdir -p features/auth/data/datasources
mkdir -p features/auth/data/models
mkdir -p features/auth/data/repositories

mkdir -p features/auth/domain/entities
mkdir -p features/auth/domain/repositories
mkdir -p features/auth/domain/usecases

mkdir -p features/auth/presentation/bloc
mkdir -p features/auth/presentation/screens
mkdir -p features/auth/presentation/widgets
```
Let's break down this structure. It represents the three layers of Clean Architecture within the `auth` feature:
*   `data/`: The outermost layer. It knows how to fetch and store data from the API and local cache.
*   `domain/`: The core layer. It contains the business rules and logic. It has zero knowledge of the `data` or `presentation` layers.
*   `presentation/`: The UI layer. It contains the Flutter widgets, screens, and the BLoC to manage their state.

**Your `lib` folder should now look exactly like this:**

```
lib/
├── core/
│   ├── api/
│   ├── config/
│   ├── errors/
│   ├── navigation/
│   ├── services/
│   └── utils/
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── screens/
│           └── widgets/
```

---

### **Mission 5.3: Arming the Project with Dependencies**

A scout is useless without its equipment. We will now edit `pubspec.yaml` to include our core packages.

1.  Open `coherency-platform/src/frontend/pubspec.yaml`.
2.  Find the `dependencies:` section.
3.  **Replace** the existing `cupertino_icons` entry with this full block. This is our non-negotiable toolkit.

    ```yaml
    dependencies:
      flutter:
        sdk: flutter
    
      # State Management
      flutter_bloc: ^8.1.3
    
      # Networking
      dio: ^5.3.3
      
      # Dependency Injection / Service Location
      get_it: ^7.6.4
      
      # Navigation
      go_router: ^12.1.1
    
      # Functional Programming & Utilities
      equatable: ^2.0.5
      dartz: ^0.10.1 # Crucial for Either<Failure, Success> pattern
      
      # Secure Storage
      flutter_secure_storage: ^9.0.0
    
      # Environment Variable Management
      flutter_dotenv: ^5.1.0
    
    dev_dependencies:
      flutter_test:
        sdk: flutter
    
      # Code Generation & Linting
      build_runner: ^2.4.6
      flutter_lints: ^2.0.0
    ```
4.  After saving the file, run the package installation command from the `src/frontend` directory:

    ```bash
    flutter pub get
    ```

### **Mission 5.4: The Genesis File (`main.dart`)**

Now that the structure is in place, we will create the application's entry point.

1.  Create a new file at `coherency-platform/src/frontend/lib/main.dart`.
2.  Paste the following minimal code into it.

    ```dart
    import 'package:flutter/material.dart';
    
    void main() {
      // Later, we will add service locator setup and other initializations here.
      runApp(const CoherencyApp());
    }
    
    class CoherencyApp extends StatelessWidget {
      const CoherencyApp({super.key});
    
      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'Coherency',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Coherency'),
            ),
            body: const Center(
              child: Text('Frontend Foundation: Secure and Operational.'),
            ),
          ),
        );
      }
    }
    ```
3.  Run a final verification from the `src/frontend` directory:

    ```bash
    flutter analyze
    ```
    This should report `0 issues found!`.

**Mission Complete.**

You have successfully constructed the frontend project. It is clean, structured for scalability using industry-best practices, and armed with the necessary dependencies. The `features/auth/` directory is now ready to be populated with the code for your authentication system, following the Clean Architecture pattern you have established.

The framework for our entire software empire is now in place. You have a backend solution and a frontend application, both built on solid, professional foundations.

The planning phase is over. **Implementation begins now.**
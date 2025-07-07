lib/
├── main.dart
├── app/
│   ├── app.dart                 # Main app widget
│   └── routes/
│       └── app_routes.dart      # Route definitions
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # Color palette
│   │   ├── app_dimensions.dart  # Spacing, sizes
│   │   └── app_strings.dart     # Text constants
│   ├── theme/
│   │   └── app_theme.dart       # Theme configuration
│   └── utils/
│       └── validators.dart      # Input validation
├── features/
│   └── authentication/
│       ├── presentation/
│       │   ├── pages/
│       │   │   └── login_page.dart
│       │   └── widgets/
│       │       ├── sacred_geometry_background.dart
│       │       ├── floating_login_form.dart
│       │       └── animated_logo.dart
│       ├── domain/
│       │   └── models/
│       │       └── user_model.dart
│       └── data/
│           └── repositories/
│               └── auth_repository.dart
└── shared/
    └── widgets/
        ├── custom_text_field.dart
        └── gradient_button.dart


        
# Recipe Management App

A Flutter application for managing recipes with Firebase authentication and SQLite local storage.

## Features

- User authentication (Sign up/Login)
- View recipes from TheMealDB API
- Create, Read, Update, Delete (CRUD) recipe operations
- Local data persistence using SQLite
- Recipe search and filtering
- Category-based organization
- Image upload support
- Responsive design

## State Management & Dependencies

- Provider for state management
- ValueNotifier for reactive UI updates
- Key packages used:
  - `firebase_core` & `firebase_auth` for authentication
  - `sqflite` for local database
  - `image_picker` for image selection
  - `http` for API calls
  - `shared_preferences` for local storage
  - `provider` for state management

## Prerequisites

Before running the app, make sure you have:

1. Flutter SDK installed (version 3.0.0 or higher)
2. Firebase project set up
3. Android Studio/VS Code with Flutter plugins
4. Android emulator or physical device

## Setup Instructions

1. Clone the repository:
```bash
git clone https://github.com/your-username/FourtitudeAssessment.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android/iOS apps in Firebase console
   - Download and add google-services.json to android/app/
   - Add GoogleService-Info.plist to ios/Runner/

4. Setup local database:
   - The app will automatically create required tables on first run
   - No additional setup needed for SQLite

## Running the App

1. Development mode:
```bash
flutter run lib/flavors/main_development.dart
```

## Project Structure

```
lib/
├── configs/          # App configurations
├── modules/          # Feature modules
│   ├── screens/      # UI screens
│   ├── services/     # Business logic
│   └── logins/       # Authentication
├── commons/          # Shared utilities
└── flavors/          # Different app flavors
```

## Database Schema

The app uses SQLite with the following main table:

```sql
CREATE TABLE recipes (
    id TEXT PRIMARY KEY,
    datasource TEXT,
    name TEXT,
    type TEXT,
    source TEXT,
    imagePath TEXT,
    dateInsert TEXT
)
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
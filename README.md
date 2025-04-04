# Chat Application

A modern real-time chat application built with Flutter, featuring a clean architecture and robust state management. This application is built on top of a Go backend server.

## Features

- Real-time messaging using WebSocket
- Clean Architecture implementation
- State management using BLoC pattern
- Secure storage for user credentials
- Persistent data storage with Hydrated BLoC
- Cross-platform support (iOS, Android, Web, Linux)
- Go backend server for handling chat operations

## Backend

This application depends on a Go backend server. The backend repository can be found at:
[https://github.com/younesbeheshti/chatapp-backend.git](https://github.com/younesbeheshti/chatapp-backend.git)

### Backend Setup

1. Clone the backend repository:
```bash
git clone https://github.com/younesbeheshti/chatapp-backend.git
```

2. Follow the setup instructions in the backend repository to get the server running.

3. Make sure the backend server is running before starting the Flutter application.

## Project Structure

The project follows a clean architecture approach with the following structure:

```
lib/
├── core/           # Core functionality and utilities
├── data/           # Data layer (repositories, data sources)
├── domain/         # Business logic and entities
├── presentation/   # UI layer (screens, widgets, blocs)
├── main.dart       # Application entry point
└── service_locator.dart  # Dependency injection setup
```

## Dependencies

### Frontend Dependencies
- **flutter_bloc**: ^9.0.0 - State management
- **hydrated_bloc**: ^10.0.0 - Persistent state management
- **web_socket_channel**: ^3.0.2 - Real-time communication
- **get_it**: ^8.0.3 - Dependency injection
- **http**: ^1.3.0 - HTTP client
- **flutter_secure_storage**: ^9.2.4 - Secure storage
- **equatable**: ^2.0.7 - Value equality

### Backend Dependencies
The backend is built with Go and includes its own set of dependencies. Please refer to the backend repository for detailed information about backend dependencies.

## Getting Started

### Prerequisites

- Flutter SDK (^3.5.3)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Go backend server running

### Installation

1. Clone the repository:
```bash
git clone https://github.com/younesbeheshti/unigram-chat-app.git
```

2. Navigate to the project directory:
```bash
cd chat_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Make sure the backend server is running (follow the backend setup instructions)

5. Run the application:
```bash
flutter run
```

## Architecture

The application follows Clean Architecture principles:

- **Presentation Layer**: Contains UI components, BLoC for state management
- **Domain Layer**: Business logic, entities, and repository interfaces
- **Data Layer**: Implementation of repositories and data sources

The application communicates with the Go backend server through REST APIs and WebSocket connections for real-time chat functionality.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- BLoC pattern for state management
- Clean Architecture by Robert C. Martin
- Go backend team for the server implementation
    
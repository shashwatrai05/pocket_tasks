# PocketTasks Mini 📝

A beautiful and efficient task management app built with Flutter. Stay organized and boost your productivity with a clean, modern interface that adapts to your workflow.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

### Core Functionality
- **Add Tasks**: Quick task creation with validation
- **Smart Search**: Debounced search with 300ms delay for smooth performance
- **Advanced Filtering**: Filter by All, Active, or Completed tasks
- **Task Management**: 
  - Tap to toggle task completion
  - Swipe left to delete tasks
- **Undo Support**: Comprehensive undo functionality for all actions
- **Persistent Storage**: Tasks survive app restarts using SharedPreferences

### UI/UX Excellence
- **Responsive Design**: Optimized for phones and tablets
- **Theme Support**: Beautiful light and dark themes adaptive to device theme
- **Smooth Animations**: Custom animations and transitions
- **Progress Tracking**: Real-time circular progress indicator
- **Modern Design**: Material 3 design system with custom gradients

### Technical Features
- **High Performance**: Efficient ListView.builder handles 100+ tasks smoothly
- **State Management**: Clean Riverpod architecture for reactive updates
- **Custom Painter**: Hand-crafted circular progress ring with shimmer effects
- **Debounced Input**: Optimized search performance
- **Comprehensive Testing**: Unit tests for core functionality

## 🏗️ Architecture

```
lib/
├── core/
│   └── utils/
│       └── debouncer.dart          # Debounced input handling
├── data/
│   └── task_repository.dart        # Data persistence layer
├── models/
│   └── task.dart                   # Task data model
├── providers/
│   └── task_provider.dart          # State management (Riverpod)
├── ui/
│   ├── screens/
│   │   └── home_screen.dart        # Main application screen
│   └── widgets/
│       ├── add_task_field.dart     # Task creation widget
│       ├── filter_chips.dart       # Filter selection chips
│       ├── progress_ring.dart      # Custom circular progress (CustomPainter)
│       └── task_list.dart          # Task list and item widgets
└── main.dart                       # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android/iOS device or simulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/pocket-tasks.git
   cd pocket-tasks
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🧪 Testing

### Running Tests

Execute unit tests with detailed output:
```bash
flutter test --reporter=expanded
```

For basic test execution:
```bash
flutter test
```

### Test Coverage

Run tests with coverage report:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Available Tests

- **Search & Filter Tests**: Comprehensive testing of the filtering logic
  - All/Active/Done filter validation
  - Text query filtering (case-insensitive)
  - Combined filter scenarios
  - Task ordering (newest first)

**Test File Location**: `test/task_tests.dart`

## 📱 Usage Guide

### Adding Tasks
1. Tap the text field under "Add New Task"
2. Type your task title (max 100 characters)
3. Press Enter or tap the + button
4. Invalid submissions show inline errors

### Managing Tasks
- **Complete/Uncomplete**: Tap any task to toggle its status
- **Delete**: Swipe left on any task and confirm deletion
- **Undo**: Use the undo button in the snackbar after any action

### Searching & Filtering
- **Search**: Use the search bar to find tasks by title
- **Filter**: Tap filter chips (All/Active/Complete) to view specific task types
- **Combined**: Search and filter work together for precise results

### Progress Tracking
- View completion percentage in the header progress ring
- Real-time updates with smooth animations
- Shimmer effect when no tasks exist

## 🎨 Customization

### Themes
The app automatically adapts to system theme preferences:
- **Light Theme**: Clean white backgrounds with purple accents
- **Dark Theme**: Deep blue backgrounds with consistent branding

### Colors
Primary brand colors are defined in `main.dart`:
```dart
const primaryColor = Color(0xFF4D55BB);  // Main brand color
const secondary = Color(0xFF6366F1);     // Secondary accent
const tertiary = Color(0xFF8B5CF6);      // Gradient accent
```

## 🏗️ Technical Implementation

### State Management
- **Riverpod**: Modern, compile-safe state management
- **Reactive Updates**: UI automatically updates when data changes
- **Provider Architecture**: Clean separation of concerns

### Performance Optimizations
- **ListView.builder**: Efficient rendering of large task lists
- **Debounced Search**: 300ms delay prevents excessive API calls
- **Memory Management**: Proper disposal of controllers and animations

### Data Persistence
- **SharedPreferences**: Reliable local storage
- **JSON Serialization**: Efficient data encoding/decoding
- **Error Handling**: Graceful fallbacks for corrupted data

### Custom Components
- **Progress Ring**: Hand-painted circular progress with CustomPainter
- **Animated Transitions**: Smooth list item animations
- **Responsive Design**: Adapts to different screen sizes


---

**Built with ❤️ using Flutter**

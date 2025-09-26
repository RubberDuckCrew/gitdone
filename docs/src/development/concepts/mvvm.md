# Model‐View‐ViewModel (MVVM)

## What is MVVM?

**MVVM (Model-View-ViewModel)** is a software architectural pattern that helps separate concerns in application development. It improves code organization, testability, and maintainability by splitting an app into three core components:

## Components

-   **Model**:
    The data layer. It includes business logic, domain models, and data services (e.g., API calls, database access).
    → Example: `User`,`UserService`

-   **View**:
    The UI layer. It consists of widgets and visual components that display data to the user and forward user interactions.
    → Example: `UserPage`, `UserCardWidget`

-   **ViewModel**:
    Acts as a bridge between the Model and the View. It holds and transforms data coming from the Model to a format usable by the View, and handles user input logic.
    → Example: `UserViewModel`

## How we implement MVVM in Flutter

We use the **MVVM pattern** in combination with `Provider`.

### Folder Structure

We follow a clean MVVM structure organized like this:

```
lib/
├── core/
│   ├── models/
│   │   └── user.dart
│   └── theme/
│       └── app_theme.dart
└── ui/
    ├── _widgets/
    │   └── custom_button.dart
    └── feature_name/
        ├── feature_name_screen.dart
        ├── feature_name_view.dart
        └── feature_name_view_model.dart
```

### Example

-   **Model:** `user.dart`

```dart
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}
```

-   **Service:** `user_service.dart`

```dart
class UserService {
  Future<User> fetchUser() async {
    await Future.delayed(Duration(seconds: 1));
    return User(name: 'John Doe', age: 30);
  }
}
```

-   **ViewModel:**`user_view_model.dart`

```dart
import 'package:flutter/material.dart';
import '../../../services/user_service.dart';
import '../../../models/user.dart';

class UserViewModel extends ChangeNotifier {
  final UserService _userService;

  UserViewModel(this._userService);

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    _user = await _userService.fetchUser();

    _isLoading = false;
    notifyListeners();
  }
}
```

-   **View:**`user_page.dart`

```dart
class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text("User")),
      body: Center(
        child: viewModel.isLoading
            ? CircularProgressIndicator()
            : viewModel.user == null
                ? Text("No user loaded")
                : Text("Name: ${viewModel.user!.name}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => viewModel.loadUser(),
        child: Icon(Icons.download),
      ),
    );
  }
}

```

# Provider Dependency Injection

Dependency injection is a fundamental principle in MVVM architecture. It enables better separation of concerns, improves testability, and makes your codebase more maintainable. In Flutter, the `provider` package is widely used to implement dependency injection and manage state.

When working with the `provider` package in a Flutter MVVM setup, you frequently need to access your `ViewModel` from the `View`. There are several approaches to do this, each affecting widget rebuilds and performance differently.

This guide covers the **three most common techniques** for accessing your ViewModel:

-   `Provider.of<T>(context)`
-   `context.read<T>()`
-   `context.watch<T>()`

## `Provider.of<T>(context)`

```dart
final viewModel = Provider.of<AuthViewModel>(context, listen: false);
viewModel.login(email, password);
```

### Use Case

-   To **access methods or values** in your ViewModel.
-   You can choose whether the widget should rebuild using the `listen` parameter.

### Rebuild behavior

| listen           | Effect                                 |
| ---------------- | -------------------------------------- |
| `true` (default) | Widget rebuilds when the model updates |
| `false`          | No rebuild on model updates            |

### Recommended

Use with `listen: false` when you're only calling a method or accessing data _without needing the UI to update_.

## `context.read<T>()`

```dart
context.read<AuthViewModel>().logout();
```

### Use Case:

-   Best for **calling methods or retrieving data** _without triggering a rebuild_.
-   Equivalent to `Provider.of<T>(context, listen: false)`, but more concise.

### Rebuild behavior:

-   ❌ **No rebuild** of the widget.

### Recommended:

Use inside event handlers like button presses where you don’t need the widget to react to ViewModel changes.

## `context.watch<T>()`

```dart
final isLoggedIn = context.watch<AuthViewModel>().isLoggedIn;
```

### Use Case

-   Use this when you want the **UI to automatically update** when the ViewModel’s value changes.

### Rebuild behavior:

-   ✅ **Widget rebuilds** every time the watched property changes.

### Recommended:

Use in the `build` method or widgets that should dynamically respond to state changes.

## Comparison

| Method                    | Rebuilds Widget?            | Use Case                                   |
| ------------------------- | --------------------------- | ------------------------------------------ |
| `Provider.of<T>(context)` | ✅ / ❌ (based on `listen`) | General-purpose access                     |
| `context.read<T>()`       | ❌ No                       | Call methods / read values without rebuild |
| `context.watch<T>()`      | ✅ Yes                      | Automatically update UI on model changes   |

## Example

```dart
class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () {
              context.read<AuthViewModel>().login();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text('Login'),
    );
  }
}
```

## Summary

Choosing the right approach depends on **what you're trying to do**:

-   Use `context.read` for **method calls** (e.g. inside `onPressed`)
-   Use `context.watch` for **UI that reacts** to changes
-   Use `Provider.of` if you need more control, but prefer `read/watch` for clarity

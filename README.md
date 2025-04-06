<p align="center">
  <img src="assets/icons/app/gitdone.svg" alt="gitdone logo" width="150"/>
</p>

# GitDone

**Gitdone** is a Flutter-based mobile app designed to simplify your workflow by turning your to-dos
directly into GitHub issues. Stay organized and keep your development tasks in sync, right from your
phone.

## 🚀 Features

- 🔐 GitHub authentication (OAuth)
- 📝 Manage your to-dos as GitHub issues (planned)
- 🔄 GitHub integration for issue syncing (planned)
- 📦 Lightweight Flutter Android app

> ⚠️ Project is in early development. Currently, only GitHub login is implemented.

## 🛠️ Development

### Requirements

- Flutter SDK installed ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart (comes with Flutter)
- Android device or emulator

### Setup

```bash
flutter pub get
flutter build apk
```

Then install the APK on your device or run with:

```bash
flutter run
```

## 🤝 Contributing

We welcome contributions! To keep things clean and consistent, please follow these guidelines:

### 🧑‍💻 Git Workflow

-   Use **feature branches** with clear names:  
    Examples: `feature/login-ui`, `fix/issue-sync-crash`, `chore/update-deps`
-   Open Pull Requests to the `main` branch.

### 📝 Commit Messages

- Use [Gitmojis](https://gitmoji.dev/) for commit messages.
  Example:
  ```
  ✨ Add GitHub login flow
  ```

### 📐 Code Style

-   Follow Dart and Flutter best practices
-   Run `flutter analyze` before committing
- Follow Dart and Flutter best practices
- Run `flutter analyze` before committing

## 🧪 CI/CD

Planned:

- GitHub Actions for:
    - Building APKs
    - Running tests
    - Code analysis and formatting checks

## 📄 License

This project is licensed under the [MIT License](LICENSE).

## 📚 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [GitHub REST API](https://docs.github.com/en/rest)
- [Gitmoji Guide](https://gitmoji.dev/)

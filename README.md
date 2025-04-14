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

## 📅 Roadmap

### [Alpha Release](https://github.com/RubberDuckCrew/gitdone/milestone/1)

See [milestone](https://github.com/RubberDuckCrew/gitdone/milestone/1) for future features and improvements.

### Future Features

- [ ] Notifications for issue updates
- [ ] Offline support
- [ ] User settings
- [ ] Multi-account support

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

### 🧑‍💻 Branch Naming Convention

Use **feature branches** with one of the following **prefixes** to clearly indicate the purpose of
the branch.  
Only the prefixes listed below are allowed. Each one comes with a matching Gitmoji, description, and
usage example.

| Prefix      | Gitmoji | Description                                            | Example                       |
|-------------|---------|--------------------------------------------------------|-------------------------------|
| `feature/`  | ✨       | Implementing a new feature or major functionality      | `feature/user-authentication` |
| `fix/`      | 🐛      | Fixing a bug, issue, or regression                     | `fix/crash-on-startup`        |
| `hotfix/`   | 🚑️     | Urgent or production-critical fix                      | `hotfix/login-failure`        |
| `docs/`     | 📝      | Documentation updates or improvements                  | `docs/api-usage-guide`        |
| `test/`     | 🧪      | Adding or updating tests (unit, integration, etc.)     | `test/user-service-tests`     |
| `refactor/` | ♻️      | Code refactoring without changing existing behavior    | `refactor/database-layer`     |
| `style/`    | 🎨      | UI/UX improvements or code formatting                  | `style/button-alignment`      |
| `ci/`       | ⚙️      | CI/CD or automation pipeline changes                   | `ci/update-pipeline`          |
| `perf/`     | ⚡️      | Improving performance or efficiency                    | `perf/cache-optimization`     |
| `i18n/`     | 🌍      | Localization or translation work                       | `i18n/add-french-language`    |
| `security/` | 🔒️     | Fixing or improving security-related functionality     | `security/fix-token-leak`     |
| `release/`  | 📦      | Preparing or managing a new release                    | `release/v2.1.0`              |
| `chore/`    | 🛠️     | General maintenance, dependency updates, tooling, etc. | `chore/update-eslint`         |

All branches must be based on the `main` branch.

Once your work is ready, open a **Pull Request** to merge your branch into `main`. It should be in
the following format:

```
🔀[gitmoji] [Description]
```

**Tip:** Use short, descriptive branch names. Prefer dashes (`-`) to separate words.

### 📝 Commit Messages

- Use [Gitmojis](https://gitmoji.dev/) for commit messages.
  Example:
  ```
  ✨ Add GitHub login flow
  ```

### 📐 Code Style

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

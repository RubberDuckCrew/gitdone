# CI/CD Workflows

This project uses several GitHub Actions workflows to automate CI/CD processes. Most reusable workflows (such as label syncing, conventions, documentation, and security scanning) are already documented in the [RubberDuckCrew CI/CD Guide](https://rubberduckcrew.pages.dev/development/ci-cd).

## Test Build Release Workflow

The `test-build-release.yml` workflow is the central pipeline for building, testing, and releasing the application. It is triggered on key events such as pushes to main branches, pull requests, and releases.

This workflow ensures that every change is validated and that releases are consistent and reproducible.

### Workflow Steps

-   **Checkout & Setup:** Checks out the repository and sets up the required environment (e.g., Flutter, Dart, Node.js).
-   **Dependency Installation:** Installs all necessary dependencies for both the Flutter app and any supporting scripts.
-   **Testing:** Runs unit and widget tests to ensure code quality and correctness.
-   **Build:** Builds the application for supported platforms (Android, iOS, Web, etc.).
-   **Release:** On release events, it packages and publishes the build artifacts (e.g., APKs, web bundles) to the appropriate destinations (GitHub Releases, package registries, etc.).
-   **Artifacts:** Uploads build and test artifacts for later inspection or download.

### Triggers

Format checks, dart analysis, and tests are triggered on every push and pull request to ensure code quality before merging.

The build of the app is only triggered manually by adding the `⚗️ Request Build` label to a pull request. This is to avoid unnecessary builds on every code change, saving CI resources and time because building the app takes quite a while. After the build is complete, the label is automatically removed from the pull request and the artifacts are posted as a comment for easy access.

## Other Workflows

In addition to the main `test-build-release.yml` workflow, there are several other workflows that handle specific tasks or processes within the project. These include:

-   **Actionlint:** Lints GitHub Actions workflows for best practices.
-   **Add Project:** Automates the process of adding new issues to our issue tracker.
-   **Close Actions:** Automatic actions on issue and pull request closing.
-   **Convention Checks:** Enforces coding standards and project conventions.
-   **Documentation Build and Deployment:** Automatically generates and deploys documentation changes.
-   **OSV Scanner:** Checks for vulnerabilities in dependencies using the Open Source Vulnerability (OSV) database.
-   **Label Syncing:** Ensures that issue labels are consistent across the repository.

These workflows are centralized for the whole RubberDuckCrew organization in the [RubberDuckCrew/.github](https://github.com/RubberDuckCrew/.github) repository. They are documented in detail in the [RubberDuckCrew CI/CD documentation](https://rubberduckcrew.pages.dev/development/ci-cd).

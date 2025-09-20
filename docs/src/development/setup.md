# Development Environment Setup

This document describes how to set up a Flutter development environment for this project.  
We recommend installing Flutter via the **SDK ZIP archive**, not through Visual Studio Code or other package managers, to ensure a consistent setup across all team members.

::: info
This guide is only a summary of the official Flutter installation instructions. Please refer to the [official Flutter installation guide](https://docs.flutter.dev/install/manual) for more detailed information and troubleshooting.
:::

## Prerequisites

### Windows

1. Download and install the latest version of [Git for Windows](https://git-scm.com/download/win).
2. Set up an editor or IDE that [supports Flutter](https://docs.flutter.dev/tools/editors). We recommend [Android Studio](https://developer.android.com/studio).

### macOS

1. Install the Xcode command-line tools including git:

    ```bash
    xcode-select --install
    ```

2. Set up an editor or IDE that [supports Flutter](https://docs.flutter.dev/tools/editors).

### Linux

Download and install prerequisite packages: `curl`, `git`, `unzip`, `xz-utils`, `zip`, `libglu1-mesa`

For Debian/Ubuntu run:

```bash
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
```

### Chrome OS

1. Enable Linux (Beta) on your Chromebook.
2. Follow the [Linux instructions](#linux) above.

## Install Flutter SDK

1. Download the latest **stable** Flutter SDK ZIP:

    - [Flutter SDK downloads](https://docs.flutter.dev/get-started/install)

2. Extract the ZIP to a desired location: `<your-path>/flutter`

    ::: warning
    The path may not contain any spaces and must not require elevated privileges.
    :::

3. Add Flutter to your PATH:

    - **Windows (PowerShell):**
        ```powershell
        setx PATH "$($env:PATH);<your-path>\flutter\bin"
        ```
    - **macOS/Linux (bash/zsh):**
        ```bash
        export PATH="$PATH:<your-path>/flutter/bin"
        ```

4. Verify installation:

    ```bash
    flutter doctor
    ```

    ::: info
    Some issues may be reported, which is normal at this stage. We will address them in the following steps.
    :::

## Set Up Android Development

1. Download and install [Android Studio](https://developer.android.com/studio).

2. During setup, make sure to install:

    - Newest Android SDK
    - Android SDK Build-Tools
    - NDK
      :::warning
      The NDK version must match the one specified in [`android/app/build.gradle`](https://github.com/RubberDuckCrew/gitdone/blob/main/android/app/build.gradle.kts#L14) because of native dependencies.
      :::
    - Android Emulator (if you plan to use it)
    - Android SDK Platform-Tools
    - Google USB Driver (for Windows users to connect physical devices)

3. Open Android Studio and install the **Flutter** and **Dart** plugins.

4. Accept android licenses:

    ```bash
    flutter doctor --android-licenses
    ```

## Verify Setup

Run the following command to check if everything is set up correctly:

```bash
flutter doctor
```

Fix any issues listed in the output before proceeding.

:::info
Some issues may remain, such as missing Visual Studio or iOS tools. These can be ignored if you don't plan to develop for those platforms.
:::

## Setup Project

Clone the project repository using git and install dependencies:

```bash
git clone https://github.com/RubberDuckCrew/gitdone.git
cd gitdone
flutter pub get
```

## Run the App

1. Connect a physical device or start an emulator.

2. Run the app:

    ```bash
    flutter run
    ```

    ::: info
    The first run may take a while as Flutter needs to download many gradle dependencies.
    :::

3. To run on a specific platform, use:

    ```bash
    flutter run -d <device-id>
    ```

    You can list all connected devices with `flutter devices`.

4. To build a release version, use:

    ```bash
    flutter build <platform> -PskipSigning=true
    ```

    Replace `<platform>` with `apk`, `appbundle`, `ios`, `web`, etc. See [Flutter's build documentation](https://docs.flutter.dev/deployment) for more details.

    ::: info
    The `-PskipSigning=true` flag is used to skip the signing process for the release build because we only use signing in the CI/CD build pipelines.
    :::

## Additional steps

### Formatter and Analyzer

We use the dart formatter and analyzer to ensure code quality. You can run them with:

```bash
dart format .
dart analyze
```

To automatically format code on save, configure your IDE accordingly. See [Flutter's guide](https://docs.flutter.dev/development/tools/formatting) for more information.

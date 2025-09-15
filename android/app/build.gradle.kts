import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.GitDone.gitdone"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.2.12479018"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.GitDone.gitdone"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Signing via -PskipSigning=true
    val skipSigning = project.hasProperty("skipSigning") && project.property("skipSigning") == "true"

    signingConfigs {
        if (!skipSigning) {
            create("release") {
                val keystoreProperties = Properties()
                val keystorePropertiesFile = rootProject.file("key.properties")
                if (keystorePropertiesFile.exists()) {
                    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                }
                storeFile = file("key.jks")
                keyAlias = keystoreProperties["keyAlias"] as? String
                keyPassword = keystoreProperties["keyPassword"] as? String
                storePassword = keystoreProperties["storePassword"] as? String
            }
        }
    }

    buildTypes {
        release {
            if (!skipSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                println("Building unsigned release (signing skipped).")
            }
        }
    }

    flavorDimensions += "default"
    productFlavors {
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "GitDone Dev")
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".stg"
            resValue("string", "app_name", "GitDone Test")
        }
        create("production") {
            dimension = "default"
            resValue("string", "app_name", "GitDone")
        }
    }
}

flutter {
    source = "../.."
}

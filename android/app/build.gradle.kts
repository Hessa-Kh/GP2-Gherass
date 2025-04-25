plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Google Services plugin
    id("com.google.firebase.crashlytics") // Firebase Crashlytics
    id("kotlin-android") // Kotlin Android plugin
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin (must be after Android & Kotlin plugins)
}

android {
    namespace = "com.leadergroup.gherass.gherass"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"  // Make sure this is correct for your project

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.leadergroup.gherass.gherass"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug") // Replace with your release signing config
        }
    }
}

flutter {
    source = "../.." // Ensure this points to the correct location of your Flutter project
}

// Ensure that Firebase Crashlytics and Google Services configurations are correct.

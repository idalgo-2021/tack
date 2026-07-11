import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.tack.app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.tack.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    val keyProps = rootProject.file("key.properties").let { file ->
        if (file.exists()) Properties().apply { load(file.inputStream()) }
        else null
    }

    buildTypes {
        release {
            val storeFile = keyProps?.getProperty("storeFile")
                ?: System.getenv("KEYSTORE_PATH")
            val storePassword = keyProps?.getProperty("storePassword")
                ?: System.getenv("KEYSTORE_PASSWORD")
            val keyAlias = keyProps?.getProperty("keyAlias")
                ?: System.getenv("KEY_ALIAS")
            val keyPassword = keyProps?.getProperty("keyPassword")
                ?: System.getenv("KEY_PASSWORD")

            if (storeFile != null && storePassword != null && keyAlias != null && keyPassword != null) {
                signingConfig = signingConfigs.create("release") {
                    this.storeFile = file(storeFile)
                    this.storePassword = storePassword
                    this.keyAlias = keyAlias
                    this.keyPassword = keyPassword
                }
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

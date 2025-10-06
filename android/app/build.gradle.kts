import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.eventapp.scout"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    fun getProperty(name: String, file: File): String {
        val properties = Properties()
        properties.load(FileInputStream(file))
        return properties.getProperty(name)
    }

    val keystorePropertiesFile = rootProject.file("key.properties")

    val releaseSigningConfig = signingConfigs.maybeCreate("release")

    if (keystorePropertiesFile.exists()) {
        println("🧩 Reading key.properties file.")
        releaseSigningConfig.apply {
            storeFile = file(getProperty("storeFile", keystorePropertiesFile))
            storePassword = getProperty("storePassword", keystorePropertiesFile)
            keyAlias = getProperty("keyAlias", keystorePropertiesFile)
            keyPassword = getProperty("keyPassword", keystorePropertiesFile)
        }
    } else {
        println("🧩 key.properties file not found. Using debug signing for release build.")
        signingConfigs.getByName("debug").apply {
            releaseSigningConfig.storeFile = storeFile
            releaseSigningConfig.storePassword = storePassword
            releaseSigningConfig.keyAlias = keyAlias
            releaseSigningConfig.keyPassword = keyPassword
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.eventapp.scout"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Enable MultiDex
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = releaseSigningConfig

            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        // ... (other build types, e.g., debug)
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.multidex:multidex:2.0.1")
}

flutter {
    source = "../.."
}

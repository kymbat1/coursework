// android/build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Google Services plugin для Firebase
        classpath("com.google.gms:google-services:4.4.4")
    }
}

plugins {
    // Kotlin и Android
    id("com.android.application") apply false
    id("kotlin-android") apply false
    // Google Services подключается через buildscript
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Настройка общего buildDirectory (если нужно)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

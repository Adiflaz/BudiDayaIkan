#!/bin/bash
echo "Setup Project Budidaya Ikan..."

# Buat struktur folder
mkdir -p ~/BudiDayaIkan/{app/src/{main/{java/com/adif/budidaya,res/{layout,values,xml,drawable}},test},gradle/wrapper}

# Buat file gradle
cd ~/BudiDayaIkan

cat > build.gradle << 'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.2.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

cat > app/build.gradle << 'EOF'
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.adif.budidaya'
    compileSdk 34

    defaultConfig {
        applicationId "com.adif.budidaya"
        minSdk 21
        targetSdk 34
        versionCode 1
        versionName "1.0"
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
    
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
    implementation 'com.google.android.material:material:1.10.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.cardview:cardview:1.0.0'
}
EOF

cat > gradle.properties << 'EOF'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.enableJetifier=true
EOF

cat > settings.gradle << 'EOF'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "BudiDayaIkan"
include ':app'
EOF

# Buat gradlew
cat > gradlew << 'EOF'
#!/bin/sh
# Gradle wrapper untuk Termux
GRADLE_HOME="$HOME/gradle-8.5"
java -jar "$GRADLE_HOME/lib/gradle-launcher-8.5.jar" "$@"
EOF
chmod +x gradlew

echo "✅ Struktur project siap!"
echo "Sekarang salin file Java dan XML ke folder yang sesuai."
#!/bin/bash
echo "===================================="
echo "BUILD APK BUDIDAYA IKAN DI TERMUX"
echo "===================================="

# Setup environment
export JAVA_HOME="/data/data/com.termux/files/usr"
export PATH="$PATH:$JAVA_HOME/bin"
export ANDROID_HOME="$HOME/android-sdk"

echo "[1/5] Update Termux..."
pkg update -y && pkg upgrade -y

echo "[2/5] Install Dependencies..."
pkg install -y \
    openjdk-17 \
    wget \
    unzip \
    zip \
    git \
    python

echo "[3/5] Setup Android SDK..."
cd ~
if [ ! -d "android-sdk" ]; then
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    mkdir -p android-sdk/cmdline-tools
    unzip commandlinetools-linux-*.zip -d android-sdk/cmdline-tools
    mv android-sdk/cmdline-tools/cmdline-tools android-sdk/cmdline-tools/latest
    rm commandlinetools-linux-*.zip
    
    # Setup environment
    echo 'export ANDROID_HOME="$HOME/android-sdk"' >> ~/.bashrc
    echo 'export PATH="$PATH:$ANDROID_HOME/cmdline-tools/latest/bin"' >> ~/.bashrc
    source ~/.bashrc
    
    # Accept licenses
    yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses
    $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager "platform-tools" "platforms;android-34" "build-tools;34.0.0"
fi

echo "[4/5] Install Gradle..."
cd ~
if [ ! -d "gradle-8.5" ]; then
    wget https://services.gradle.org/distributions/grade-8.5-bin.zip
    unzip gradle-8.5-bin.zip
    rm gradle-8.5-bin.zip
    echo 'export PATH="$PATH:$HOME/gradle-8.5/bin"' >> ~/.bashrc
    source ~/.bashrc
fi

echo "[5/5] Membuild APK..."
cd ~/BudiDayaIkan
chmod +x gradlew
./gradlew assembleDebug

# Cek hasil
if [ -f "app/build/outputs/apk/debug/app-debug.apk" ]; then
    echo ""
    echo "✅ ✅ ✅ APK BERHASIL DIBUILD! ✅ ✅ ✅"
    echo ""
    echo "📱 File: ~/BudiDayaIkan/app/build/outputs/apk/debug/app-debug.apk"
    echo "📦 Ukuran: $(du -h app/build/outputs/apk/debug/app-debug.apk | cut -f1)"
    echo ""
    
    # Salin ke HP
    echo "📲 Menyalin ke HP..."
    termux-setup-storage
    cp app/build/outputs/apk/debug/app-debug.apk ~/storage/downloads/BudiDayaIkan_Lengkap.apk
    
    echo "🎉 APLIKASI SIAP DIGUNAKAN!"
    echo ""
    echo "FITUR UTAMA:"
    echo "1. Kalkulator Pakan & Protein"
    echo "2. Estimasi Panen Akurat"
    echo "3. Analisis Biaya Produksi"
    echo "4. Analisis Keuntungan & ROI"
    echo "5. Database Lengkap"
    echo "6. Monitoring Harian"
    echo ""
    echo "👨‍🌾 Dibuat oleh: Adif Lazuardi Imani"
    echo "📍 APK ada di folder Downloads HP"
    echo "📝 Install: File Manager → Downloads → BudiDayaIkan_Lengkap.apk"
else
    echo ""
    echo "❌ Build gagal!"
    echo "Coba periksa:"
    echo "1. Storage cukup (minimal 2GB free)"
    echo "2. Koneksi internet stabil"
    echo "3. File project lengkap"
fi
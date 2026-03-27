@echo off
echo ========================================
echo TaskFlow - Android Emulator Launcher
echo Target: Small Phone Cold Boost
echo ========================================

REM Set paths
set ANDROID_SDK_ROOT=C:\Users\%USERNAME%\AppData\Local\Android\sdk
set EMULATOR_EXE=%ANDROID_SDK_ROOT%\emulator\emulator.exe
set ADB_EXE=%ANDROID_SDK_ROOT%\platform-tools\adb.exe
set AVDMANAGER_EXE=%ANDROID_SDK_ROOT%\cmdline-tools\latest\bin\avdmanager.bat

REM Check if Android SDK exists
if not exist "%ANDROID_SDK_ROOT%" (
    echo ERROR: Android SDK not found at %ANDROID_SDK_ROOT%
    echo Please install Android Studio or Android SDK
    pause
    exit /b 1
)

REM Check if emulator exists
if not exist "%EMULATOR_EXE%" (
    echo ERROR: Android emulator not found
    echo Please install Android emulator via SDK Manager
    pause
    exit /b 1
)

REM Check if ADB exists
if not exist "%ADB_EXE%" (
    echo ERROR: ADB not found
    echo Please install Android platform tools
    pause
    exit /b 1
)

echo Checking for Small Phone Cold Boost AVD...
"%EMULATOR_EXE%" -list-avds | findstr /C:"Small_Phone_Cold_Boost" >nul
if %errorlevel% neq 0 (
    echo Creating Small Phone Cold Boost AVD...
    echo This may take a few minutes...

    REM Create AVD with small phone specifications
    "%AVDMANAGER_EXE%" create avd -n "Small_Phone_Cold_Boost" -k "system-images;android-35;google_apis;x86_64" --device "pixel_7a" --force

    if %errorlevel% neq 0 (
        echo WARNING: Could not create AVD automatically.
        echo Please create AVD manually in Android Studio with name "Small_Phone_Cold_Boost"
        echo Device: Small Phone (or similar)
        echo API Level: 35
        echo Target: Google APIs Intel x86_64 Atom System Image
    )
)

echo Starting Small Phone Cold Boost emulator...
echo This will take some time on first launch...

REM Kill any existing emulator instances
taskkill /f /im "qemu-system-x86_64.exe" 2>nul
taskkill /f /im "emulator.exe" 2>nul

REM Start emulator with cold boot and specific configuration
start "" "%EMULATOR_EXE%" -avd "Small_Phone_Cold_Boost" -no-snapshot-load -wipe-data -gpu swiftshader_indirect -memory 2048 -cores 2 -skin 1080x2400

echo Waiting for emulator to boot...
timeout /t 10 /nobreak >nul

REM Wait for device to be ready
echo Waiting for device...
:wait_loop
"%ADB_EXE%" devices | findstr /C:"emulator-" >nul
if %errorlevel% neq 0 (
    echo Still waiting for emulator...
    timeout /t 5 /nobreak >nul
    goto wait_loop
)

echo Emulator is ready!
echo You can now run: flutter run --device-id emulator-5554
echo Or use VS Code Flutter extension to select the emulator device.

pause
@echo off
echo ========================================
echo TaskFlow - Android SDK/NDK Verification
echo ========================================

REM Set paths
set ANDROID_SDK_ROOT=C:\Users\%USERNAME%\AppData\Local\Android\sdk
set ANDROID_NDK_ROOT=%ANDROID_SDK_ROOT%\ndk\28.2.13676358
set EMULATOR_EXE=%ANDROID_SDK_ROOT%\emulator\emulator.exe
set ADB_EXE=%ANDROID_SDK_ROOT%\platform-tools\adb.exe
set AVDMANAGER_EXE=%ANDROID_SDK_ROOT%\cmdline-tools\latest\bin\avdmanager.bat

echo.
echo Checking Android SDK installation...
if exist "%ANDROID_SDK_ROOT%" (
    echo ✓ Android SDK found at: %ANDROID_SDK_ROOT%
) else (
    echo ✗ Android SDK not found!
    echo Please install Android Studio or Android SDK
    goto :error
)

echo.
echo Checking Android NDK installation...
if exist "%ANDROID_NDK_ROOT%" (
    echo ✓ Android NDK found at: %ANDROID_NDK_ROOT%
    echo ✓ NDK Version: 28.2.13676358
) else (
    echo ✗ Android NDK not found!
    echo Please install NDK 28.2.13676358 via SDK Manager
    goto :error
)

echo.
echo Checking Android Emulator...
if exist "%EMULATOR_EXE%" (
    echo ✓ Android Emulator found
) else (
    echo ✗ Android Emulator not found!
    echo Please install Android Emulator via SDK Manager
    goto :error
)

echo.
echo Checking Android Platform Tools (ADB)...
if exist "%ADB_EXE%" (
    echo ✓ ADB found
) else (
    echo ✗ ADB not found!
    echo Please install Android Platform Tools via SDK Manager
    goto :error
)

echo.
echo Checking AVD Manager...
if exist "%AVDMANAGER_EXE%" (
    echo ✓ AVD Manager found
) else (
    echo ✗ AVD Manager not found!
    echo Please install Android Command Line Tools via SDK Manager
    goto :error
)

echo.
echo Checking Flutter Android licenses...
flutter doctor --android-licenses

echo.
echo Running Flutter Doctor...
flutter doctor -v

echo.
echo ========================================
echo ✓ All Android development tools verified!
echo ========================================
echo.
echo Next steps:
echo 1. Run launch_emulator.bat to start Small Phone Cold Boost emulator
echo 2. Use VS Code debugger with "TaskFlow - Small Phone Cold Boost" configuration
echo 3. Or run: flutter run --device-id emulator-5554
echo.
pause
exit /b 0

:error
echo.
echo ========================================
echo ✗ Setup incomplete! Please fix the issues above.
echo ========================================
pause
exit /b 1
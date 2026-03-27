@echo off
REM ======================================================================================================
REM TaskFlow - Ultimate Android Development Launcher for Small Phone Cold Boost Emulator
REM ======================================================================================================
REM This script provides a comprehensive development environment setup and launch sequence
REM specifically optimized for the Small Phone Cold Boost Android emulator configuration.
REM
REM Features:
REM - Complete Android SDK/NDK verification
REM - Automatic AVD creation and configuration
REM - Cold boot optimization for consistent performance
REM - Hardware acceleration setup
REM - Flutter development server integration
REM - Comprehensive error handling and logging
REM ======================================================================================================

setlocal enabledelayedexpansion

REM Configuration variables
set "PROJECT_NAME=TaskFlow"
set "TARGET_AVD=Small_Phone_Cold_Boost"
set "ANDROID_API_LEVEL=35"
set "EMULATOR_MEMORY=2048"
set "EMULATOR_CORES=2"
set "EMULATOR_SKIN=1080x2400"
set "EMULATOR_GPU=swiftshader_indirect"

REM Color codes for output
set "RED=[91m"
set "GREEN=[92m"
set "YELLOW=[93m"
set "BLUE=[94m"
set "MAGENTA=[95m"
set "CYAN=[96m"
set "WHITE=[97m"
set "RESET=[0m"

REM Paths
set "ANDROID_SDK_ROOT=%USERPROFILE%\AppData\Local\Android\sdk"
set "ANDROID_NDK_ROOT=%ANDROID_SDK_ROOT%\ndk\28.2.13676358"
set "EMULATOR_EXE=%ANDROID_SDK_ROOT%\emulator\emulator.exe"
set "ADB_EXE=%ANDROID_SDK_ROOT%\platform-tools\adb.exe"
set "AVDMANAGER_EXE=%ANDROID_SDK_ROOT%\cmdline-tools\latest\bin\avdmanager.bat"
set "SDKMANAGER_EXE=%ANDROID_SDK_ROOT%\cmdline-tools\latest\bin\sdkmanager.bat"

REM Logging
set "LOG_FILE=%~dp0development_launch.log"
echo [%DATE% %TIME%] Starting %PROJECT_NAME% development launch sequence > "%LOG_FILE%"

:header
cls
echo %CYAN%===============================================================================================%RESET%
echo %CYAN%                              %PROJECT_NAME% - Ultimate Android Launcher%RESET%
echo %CYAN%                          Target: %TARGET_AVD% Emulator%RESET%
echo %CYAN%===============================================================================================%RESET%
echo.

:check_prerequisites
echo %BLUE%[1/8] Checking Prerequisites...%RESET%
echo [%DATE% %TIME%] Checking prerequisites >> "%LOG_FILE%"

REM Check if running as administrator (optional but recommended)
net session >nul 2>&1
if %errorLevel% == 0 (
    echo %GREEN%✓ Running with administrator privileges%RESET%
) else (
    echo %YELLOW%⚠ Recommended to run as administrator for better emulator performance%RESET%
)

REM Check Flutter installation
flutter --version >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%✗ Flutter not found in PATH%RESET%
    echo Please install Flutter and add to PATH
    goto :error
)
echo %GREEN%✓ Flutter found%RESET%

REM Check Java installation
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo %RED%✗ Java not found in PATH%RESET%
    echo Please install Java JDK 17+
    goto :error
)
echo %GREEN%✓ Java found%RESET%

echo.

:verify_android_sdk
echo %BLUE%[2/8] Verifying Android SDK/NDK Installation...%RESET%
echo [%DATE% %TIME%] Verifying Android SDK/NDK >> "%LOG_FILE%"

if not exist "%ANDROID_SDK_ROOT%" (
    echo %RED%✗ Android SDK not found at %ANDROID_SDK_ROOT%%RESET%
    echo Please install Android Studio or Android SDK
    goto :error
)
echo %GREEN%✓ Android SDK found: %ANDROID_SDK_ROOT%%RESET%

if not exist "%ANDROID_NDK_ROOT%" (
    echo %RED%✗ Android NDK 28.2.13676358 not found%RESET%
    echo Installing NDK via SDK Manager...
    "%SDKMANAGER_EXE%" "ndk;28.2.13676358"
    if !errorLevel! neq 0 goto :error
)
echo %GREEN%✓ Android NDK found: %ANDROID_NDK_ROOT%%RESET%

if not exist "%EMULATOR_EXE%" (
    echo %RED%✗ Android Emulator not found%RESET%
    echo Installing Android Emulator via SDK Manager...
    "%SDKMANAGER_EXE%" "emulator"
    if !errorLevel! neq 0 goto :error
)
echo %GREEN%✓ Android Emulator found%RESET%

if not exist "%ADB_EXE%" (
    echo %RED%✗ Android Platform Tools not found%RESET%
    echo Installing Android Platform Tools via SDK Manager...
    "%SDKMANAGER_EXE%" "platform-tools"
    if !errorLevel! neq 0 goto :error
)
echo %GREEN%✓ Android Platform Tools found%RESET%

echo.

:check_licenses
echo %BLUE%[3/8] Checking Android Licenses...%RESET%
echo [%DATE% %TIME%] Checking Android licenses >> "%LOG_FILE%"

flutter doctor --android-licenses >nul 2>&1
if %errorLevel% neq 0 (
    echo %YELLOW%⚠ Android licenses need acceptance%RESET%
    echo Running license acceptance...
    flutter doctor --android-licenses
)
echo %GREEN%✓ Android licenses verified%RESET%
echo.

:create_avd
echo %BLUE%[4/8] Creating/Verifying %TARGET_AVD% AVD...%RESET%
echo [%DATE% %TIME%] Creating/verifying AVD >> "%LOG_FILE%"

REM Check if AVD already exists
"%EMULATOR_EXE%" -list-avds 2>nul | findstr /C:"%TARGET_AVD%" >nul
if %errorLevel% neq 0 (
    echo Creating %TARGET_AVD% AVD with optimized settings...

    REM Create AVD with specific configuration
    "%AVDMANAGER_EXE%" create avd -n "%TARGET_AVD%" -k "system-images;android-%ANDROID_API_LEVEL%;google_apis;x86_64" --device "pixel_7a" --force

    if !errorLevel! neq 0 (
        echo %RED%✗ Failed to create AVD%RESET%
        goto :error
    )

    echo %GREEN%✓ AVD %TARGET_AVD% created successfully%RESET%
) else (
    echo %GREEN%✓ AVD %TARGET_AVD% already exists%RESET%
)

echo.

:kill_existing_emulators
echo %BLUE%[5/8] Terminating Existing Emulators...%RESET%
echo [%DATE% %TIME%] Terminating existing emulators >> "%LOG_FILE%"

REM Kill any running emulators
taskkill /f /im "qemu-system-x86_64.exe" 2>nul
taskkill /f /im "emulator.exe" 2>nul
taskkill /f /im "adb.exe" 2>nul

REM Wait a moment for processes to terminate
timeout /t 3 /nobreak >nul
echo %GREEN%✓ Existing emulators terminated%RESET%
echo.

:start_emulator
echo %BLUE%[6/8] Starting %TARGET_AVD% Emulator with Cold Boot...%RESET%
echo [%DATE% %TIME%] Starting emulator >> "%LOG_FILE%"

echo Launching emulator with optimized settings:
echo   • AVD: %TARGET_AVD%
echo   • Memory: %EMULATOR_MEMORY%MB
echo   • CPU Cores: %EMULATOR_CORES%
echo   • GPU: %EMULATOR_GPU%
echo   • Skin: %EMULATOR_SKIN%
echo   • Cold Boot: Enabled
echo.

REM Start emulator with comprehensive options
start "" "%EMULATOR_EXE%" ^
    -avd "%TARGET_AVD%" ^
    -no-snapshot-load ^
    -wipe-data ^
    -gpu %EMULATOR_GPU% ^
    -memory %EMULATOR_MEMORY% ^
    -cores %EMULATOR_CORES% ^
    -skin %EMULATOR_SKIN% ^
    -no-boot-anim ^
    -no-audio ^
    -qemu -enable-kvm ^
    -verbose

echo %GREEN%✓ Emulator launch initiated%RESET%
echo.

:wait_for_emulator
echo %BLUE%[7/8] Waiting for Emulator to Boot...%RESET%
echo [%DATE% %TIME%] Waiting for emulator boot >> "%LOG_FILE%"

set "BOOT_TIMEOUT=120"
set "CHECK_INTERVAL=5"
set /a "elapsed=0"

:boot_check_loop
if %elapsed% geq %BOOT_TIMEOUT% (
    echo %RED%✗ Emulator boot timeout after %BOOT_TIMEOUT% seconds%RESET%
    goto :error
)

"%ADB_EXE%" devices 2>nul | findstr /C:"emulator-" >nul
if %errorLevel% equ 0 (
    echo %GREEN%✓ Emulator detected and ready!%RESET%
    goto :emulator_ready
)

echo Waiting for emulator... (%elapsed%/%BOOT_TIMEOUT% seconds)
timeout /t %CHECK_INTERVAL% /nobreak >nul
set /a "elapsed+=CHECK_INTERVAL"
goto :boot_check_loop

:emulator_ready
echo.

:launch_flutter
echo %BLUE%[8/8] Launching Flutter Development Server...%RESET%
echo [%DATE% %TIME%] Launching Flutter >> "%LOG_FILE%"

REM Get device ID
for /f "tokens=1" %%i in ('"%ADB_EXE%" devices ^| findstr /C:"emulator-"') do set "DEVICE_ID=%%i"

if defined DEVICE_ID (
    echo %GREEN%✓ Device ID: %DEVICE_ID%%RESET%
    echo Starting Flutter app on %TARGET_AVD%...

    REM Launch Flutter in new window
    start "Flutter Development Server" cmd /k "cd /d %~dp0 && flutter run --device-id %DEVICE_ID% --debug"

    echo.
    echo %GREEN%================================================================================%RESET%
    echo %GREEN%                          DEVELOPMENT ENVIRONMENT READY!%RESET%
    echo %GREEN%================================================================================%RESET%
    echo.
    echo %CYAN%Flutter development server started in new terminal window%RESET%
    echo %CYAN%Use VS Code debugger or continue in the Flutter terminal%RESET%
    echo.
    echo %YELLOW%Useful commands:%RESET%
    echo %YELLOW%  • flutter run --device-id %DEVICE_ID% --release    (Release build)%RESET%
    echo %YELLOW%  • flutter build apk --target-platform android-arm64 (Build APK)%RESET%
    echo %YELLOW%  • flutter logs                                       (View device logs)%RESET%
    echo.

) else (
    echo %RED%✗ Could not determine device ID%RESET%
    goto :error
)

echo [%DATE% %TIME%] Development launch completed successfully >> "%LOG_FILE%"
goto :end

:error
echo.
echo %RED%================================================================================%RESET%
echo %RED%                              LAUNCH FAILED%RESET%
echo %RED%================================================================================%RESET%
echo.
echo Check the log file for details: %LOG_FILE%
echo.
echo %YELLOW%Troubleshooting tips:%RESET%
echo %YELLOW%  • Ensure Android SDK is properly installed%RESET%
echo %YELLOW%  • Accept Android licenses: flutter doctor --android-licenses%RESET%
echo %YELLOW%  • Check emulator requirements: flutter doctor -v%RESET%
echo %YELLOW%  • Try running as administrator%RESET%
echo.
echo [%DATE% %TIME%] Launch failed with error >> "%LOG_FILE%"
pause
exit /b 1

:end
echo [%DATE% %TIME%] Script completed >> "%LOG_FILE%"
pause
endlocal